//
//  QuotationDao.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import Combine

class AppState : ObservableObject {

    let session = URLSession(configuration : .default)
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    @Published var user : User
    @Published var settings : Settings
    @Published var quotations : [Chapter] = []
    @Published var chapters : [Chapter] = []
    @Published var error : ErrorType = .NoException
    @Published var chapterOfTheDay : Chapter?
    
    var allertAction : (()-> Void)?
    
    init() {
        user = User.user
        settings = Settings.setting
        start()
        AppState.state = self
    }
    
    func start() {
        if let code = user.accessCode{
            setAccessCode(code, numbers: settings.layers){
                self.user.hasAccess = self.error != .Unauthorized
                
                if !self.user.hasAccess!{
                    self.fetchQuotations()
                    self.user.accessDenied()
                }
            }
        } else{
            print("fetch quotations")
            fetchQuotations()
        }
        
        if settings.numberOfTheDay != Chapter.numberOfTheDay{
            fetchNumberOfTheDay()
        }
    }
    
    func read(){
        print("start reading")
    }
    
    func getChapters(numbers : [Int]){
        if let code = user.accessCode{
            setAccessCode(code, numbers: numbers){
                self.user.hasAccess = true
            }
        }
    }
    
    func go(to number: Int) -> Bool{
        return settings.setTop(to: number)
    }
    
    func add(number: Int) -> Bool{
        return settings.addTop(number: number)
    }
    
    func set(to number: Int) -> Bool{
        return settings.set(to: number)
    }
    
    var cancelableQuotations : AnyCancellable?
    
    func fetchQuotations()   {
        error = .Processing
        cancelableQuotations = session.dataTaskPublisher(for: AppState.quotationsurl)
            .map({$0.data})
            .map{ data -> [Chapter] in
                do{
                    return try AppState.decoder.decode([Chapter].self, from:data)
                }catch{
                    print(error)
                    return[]
                }
                
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {print($0)},
                  receiveValue:{
                    self.error = .NoException
                    self.quotations = $0
            })
    }
    
    var cancelableNumberofTheDay : AnyCancellable?
    
    func fetchNumberOfTheDay()   {
        cancelableNumberofTheDay = session.dataTaskPublisher(for: AppState.numberOfTheDayUrl)
            .map({$0.data})
            .map{ data -> Chapter? in
                do{
                    return try AppState.decoder.decode([Chapter].self, from:data)[0]
                }catch{
                    print(error)
                    return nil
                }
                
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {print($0)},
                  receiveValue:{
                    self.chapterOfTheDay = $0
                    if let chapter = self.chapterOfTheDay{
                        self.settings.setNumberOfTheDay(chapter.number)
                    }
            })
    }
    
    var cancelableLogin : AnyCancellable?
    
    fileprivate func requestChapters(with request: URLRequest,mergeType : MergeType, _ onSucces: @escaping () -> Void) {
        error = .Processing
        cancelableLogin = session
            .dataTaskPublisher(for: request)
            .map{ response -> (error: ErrorType,chapters:[Chapter]) in
                if let httpResponse = response.response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200 {
                        return (error : ErrorType(rawValue: httpResponse.statusCode)!, chapters: [])
                    }
                }
                do{
                    return (error: .NoException,
                            chapters:  try AppState.decoder.decode([Chapter].self, from: response.data))
                }catch{
                    return(error: .UnparsableResponse, chapters:[])
                }
                
        }
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: {
            print("read")
            print($0)},
              receiveValue:{
                switch mergeType{
                    case .new:
                        self.chapters = $0.chapters
                    default:
                        self.chapters.append(contentsOf: $0.chapters)
                        self.chapters = Array(Set(self.chapters))
                }
                self.error = $0.error
                onSucces()
                print($0.error)
                print($0.chapters)
        })
    }
    
    func getNumbersOfTheDay(onSucces: @escaping ()->Void){
        if let token = user.accessCode{
        
            var request = URLRequest(url: AppState.numbersOfTheDayUrl)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: AppState.authorization)
            request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
            
            requestChapters(with: request, mergeType: .new, onSucces)
        } else{
            fatalError("this function for authorized users only")
        }
    }
    
    func setAccessCode(_ accessCode: String,numbers : [Int] = [1], onSucces: @escaping ()->Void){
        var request = URLRequest(url: AppState.readsurl)
        request.httpMethod = "POST"
        request.addValue(accessCode, forHTTPHeaderField: AppState.authorization)
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        let obj : BookRequest = BookRequest(numbers : numbers)
        
        request.httpBody = AppState.encoder.optionalEncode(obj)
        
        requestChapters(with: request, mergeType: .both, onSucces)
    }
    
    fileprivate func mapChaptersToSettings() {
        self.settings.set(with: self.chapters.map({chapter in chapter.number}))
    }
    
    func textSearch(_ text: String){
        if let token = user.accessCode{
            var request = URLRequest(url: URL(string: (AppState.searchLink + text).encodedUrl)!)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: AppState.authorization)

            requestChapters(with: request, mergeType: .new){
                self.mapChaptersToSettings()
            }
        } else{
            error = .Unauthorized
        }
    }
    
    fileprivate func processUser(_ receivedUser: User) {
        receivedUser.readersAccess()
        receivedUser.storeCode(self.user.accessCode)
        self.user = receivedUser
        self.user.save()
    }
    
    func requestAuthentication(_ request: URLRequest, _ onSucces: @escaping () -> Void) {
        error = .Processing
        cancelableLogin = session
            .dataTaskPublisher(for: request)
            .map{ response -> (error: ErrorType,user: User?) in
                if let httpResponse = response.response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200 {
                        return (error : ErrorType(rawValue: httpResponse.statusCode)!, user: nil)
                    }
                }
                do{
                    return (error: .NoException,
                            user:  try AppState.decoder.decode(User.self, from: response.data))
                }catch{
                    return(error: .UnparsableResponse, nil)
                }
                
        }
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: {
            print("register")
            print($0)},
              receiveValue:{
                if let receivedUser = $0.user{
                    self.processUser(receivedUser)
                    onSucces()
                    print(receivedUser)
                }
                self.error = $0.error
                print($0.error)
                
        })
    }
    
    func loginWithCode(code: String, onError: @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        var request = URLRequest(url: AppState.codeUrl)
        request.httpMethod = "PUT"
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        
        request.httpBody = AppState.encoder.optionalEncode(TokenRequest(token: code))
        
        cancelableLogin = session
            .dataTaskPublisher(for: request)
            .map{ response -> (error: ErrorType,user: User?) in
                if let httpResponse = response.response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200 {
                        return (error : ErrorType(rawValue: httpResponse.statusCode)!, user: nil)
                    }
                }
                do{
                    return (error: .NoException,
                            user:  try AppState.decoder.decode(User.self, from: response.data))
                }catch{
                    return(error: .UnparsableResponse, nil)
                }
                
        }
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: {
            print("register")
            print($0)},
              receiveValue:{
                if $0.error == .NoException{
                    if let receivedUser = $0.user{
                        self.processUser(receivedUser)
                        onSucces()
                        print(receivedUser)
                    }else{
                        onError(.UnparsableResponse)
                    }
                }
                print($0.error)
                onError($0.error)
        })
        
    }
    
    func register(username: String, password: String, onSucces: @escaping ()->Void){
        
        var request = URLRequest(url: AppState.registerUrl)
        request.httpMethod = "POST"
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        
        request.httpBody = AppState.encoder.optionalEncode(
                Credentials(username: username, password: password))
        
        requestAuthentication(request, onSucces)
    }
    
    func login(username: String, password: String, onSucces: @escaping ()->Void){
        
        var request = URLRequest(url: AppState.loginUrl)
        request.httpMethod = "PUT"
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        
        request.httpBody = AppState.encoder.optionalEncode(
                Credentials(username: username, password: password))
        
        requestAuthentication(request, onSucces)
    }
    
    fileprivate func voidRequest(_ request: URLRequest, _ onSucces: @escaping () -> Void, _ onError: @escaping (ErrorType) -> Void) {
        cancelableLogin = session
            .dataTaskPublisher(for: request)
            .map{ response -> ErrorType in
                if let httpResponse = response.response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200 {
                        print("status code: \(httpResponse.statusCode)")
                        return ErrorType(rawValue: httpResponse.statusCode)!
                    }
                }
                return .NoException
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                    print($0)},
                  receiveValue:{
                    if $0 == .NoException{
                        onSucces()
                    } else {
                        onError($0)
                    }
                    print($0)
                  })
    }
    
    func forget(for email: String, onError: @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        var request = URLRequest(url: URL(string: (AppState.forgetLink + email).encodedUrl)!)
        request.httpMethod = "GET"
        
        voidRequest(request, onSucces, onError)
    }
    
    func changePassword(to newPassword: String, onError: @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        if let token = user.token {
            var request = URLRequest(url: AppState.changePasswordUrl)
            request.httpMethod = "POST"
            request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
            request.addValue(token, forHTTPHeaderField: AppState.authorization)
            
            request.httpBody = AppState.encoder.optionalEncode(
                    TokenRequest(token: newPassword))
            
            voidRequest(request, onSucces, onError)
        } else {
            onError(.UnparsableResponse)
        }
    }
}

//MARK: Singleton

extension AppState{
    static var state : AppState?
    static func refreshQuotations(){
        if let appState = state{
            appState.fetchQuotations()
        }
    }
    
    static func setAccessCode(_ accessCode: String, allertAction :(()->Void)?){
        if let appState = state{
            appState.allertAction = allertAction
            appState.setAccessCode(accessCode){
                if appState.error == .NoException{
                    appState.user.accessGranted(with: accessCode)
                }
            }
        }
    }
    
    static func textSearch(_ text: String){
        if let appState = state{
            appState.textSearch(text)
        }
    }
    
    static func aсquireChapter(_ number: Int, _ appState: AppState) {
        if number <= Chapter.max{
            appState.getChapters(numbers: [number])
        } else{
            appState.chapters.append(Chapter.build(from: number))
            appState.chapters = Array(Set(appState.chapters))
        }
    }
    
    static func getNumbersOfTheDay() {
        if let appState = state {
            appState.getNumbersOfTheDay {
                appState.mapChaptersToSettings()
                appState.settings.sort()
            }
        }
    }
    
    static func go(to number: Int){
        if let appState = state{
            if !appState.go(to: number){
                aсquireChapter(number, appState)
            }
        }
    }
    
    static func add(number: Int){
        if let appState = state{
            if !appState.add(number: number){
                aсquireChapter(number, appState)
            }
        }
    }
    
    static func set(to number: Int){
        if let appState = state{
            if !appState.set(to: number){
                 aсquireChapter(number, appState)
            }
        }
    }
    
    static func noException(){
        if let appState = state{
            appState.error = .NoException
        }
    }
    
    static func register(username: String, password: String, allertAction :(()->Void)?, onSucces: @escaping ()->Void){
        if let appState = state{
            appState.allertAction = allertAction
            appState.register(username: username, password: password){
                onSucces()
                appState.start()
            }
        }
    }
    
    static func login(username: String, password: String, allertAction :(()->Void)?, onSucces: @escaping ()->Void){
        if let appState = state{
            appState.allertAction = allertAction
            appState.login(username: username, password: password){
                onSucces()
                appState.start()
            }
        }
    }
    
    static func runAllertAction(){
        if let appState = state{
            if let action = appState.allertAction{
                action()
            } else {
                print("no stored action")
            }
        }
    }
    
    static func cutTop(){
        if let appState = state{
                appState.settings.cutTop()
            }
    }
    
    static func increaseFont(){
        if let appState = state{
                appState.settings.increaseFont()
            }
    }
    
    static func decreaseFont(){
        if let appState = state{
                appState.settings.decreaseFont()
            }
    }
    
    static func dismissNumberOfTheDay(){
        if let appState = state{
            appState.chapterOfTheDay = nil
        }
    }
    
    static func forget(for email: String, onError : @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        if let appState = state{
            appState.forget(for: email, onError: onError, onSucces: onSucces)
        }
    }
    
    static func loginWithCode(code: String, onError : @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        if let appState = state{
            appState.loginWithCode(code: code, onError: onError, onSucces: onSucces)
        }
    }
    
    static func changePassword(to newPassword: String, onError : @escaping (_ : ErrorType)->Void, onSucces: @escaping ()->Void){
        if let appState = state{
            appState.changePassword(to: newPassword, onError: onError, onSucces: onSucces)
        }
    }
}

//MARK: Literals

extension AppState{
    static let authorization = "Authorization"
    static let contentType = "Content-type"
    static let contentTypeJson = "application/json; charset=utf8"

}

//MARK: urls

extension AppState{
    static let serverLink = "https://everything-from.one/"
    static let quotationsLink = "free/quotations"
    static let readLink = "book/read"
    static let registerLink = "pub/register"
    static let loginLink = "pub/login"
    static let searchLink =  serverLink + "book/search/"
    static let numberOfTheDayLink = "free/day"
    static let numbersOfTheDayLink = "book/day"
    static let forgetLink = serverLink +  "pub/forget/"
    static let codeLink = "pub/code"
    static let changePasswordLink = "usr/password"
    
    static let quotationsurl = URL(string: serverLink + quotationsLink)!
    static let readsurl = URL(string: serverLink + readLink)!
    static let registerUrl = URL(string: serverLink + registerLink)!
    static let loginUrl = URL(string: serverLink + loginLink)!
    static let numberOfTheDayUrl = URL(string: serverLink + numberOfTheDayLink)!
    static let numbersOfTheDayUrl = URL(string: serverLink + numbersOfTheDayLink)!
    static let codeUrl = URL(string: serverLink +  codeLink)!
    static let changePasswordUrl = URL(string: serverLink + changePasswordLink)!
}
