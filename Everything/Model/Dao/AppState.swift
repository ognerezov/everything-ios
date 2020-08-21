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
                self.user.hasAccess = true
            }
        } else{
            print("fetch quotations")
            fetchQuotations()
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
    
    func go(to number: Int){
        settings.setTop(to: number)
    }
    
    var cancelableQuotations : AnyCancellable?
    
    func fetchQuotations()   {

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
                  receiveValue:{self.quotations = $0
                   // print($0)
            })
    
    }
    
    var cancelableLogin : AnyCancellable?
    
    func setAccessCode(_ accessCode: String,numbers : [Int] = [1], onSucces: @escaping ()->Void){
        var request = URLRequest(url: AppState.readsurl)
        request.httpMethod = "POST"
        request.addValue(accessCode, forHTTPHeaderField: AppState.authorization)
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        let obj : BookRequest = BookRequest(numbers : numbers)
        
        request.httpBody = AppState.encoder.optionalEncode(obj)
        
        error = .Processing
        cancelableLogin = session
            .dataTaskPublisher(for: request)
            .map{ response -> (error: ErrorType,chapters:[Chapter]) in
                if let httpResponse = response.response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200 {
                        return (error : ErrorType(rawValue: httpResponse.statusCode)!, chapters: [])
                    }
                }
                onSucces()
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
                    self.chapters = $0.chapters
                    self.error = $0.error
                    print($0.error)
                    print($0.chapters)
            })
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
                    if receivedUser.isReader{
                        receivedUser.accessCode = receivedUser.token
                    }
                    if receivedUser.accessCode == nil{
                        receivedUser.accessCode = self.user.accessCode
                    }
                    self.user = receivedUser
                    self.user.save()
                    onSucces()
                    print(receivedUser)
                }
                self.error = $0.error
                print($0.error)
                
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
}


//MARK: Singleton

extension AppState{
    static var state : AppState?
    static func refreshQuotations(){
        if let appState = state{
            appState.quotations = []
            appState.fetchQuotations()
        }
    }
    
    static func setAccessCode(_ accessCode: String, allertAction :(()->Void)?){
        if let appState = state{
            appState.allertAction = allertAction
            appState.setAccessCode(accessCode){
                    appState.user.accessGranted(with: accessCode)
            }
        }
    }
    
    static func go(to number: Int){
        if let appState = state{
            appState.go(to: number)
            appState.getChapters(numbers: [number])
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
    
    static func runAllertAction(){
        if let appState = state{
            if let action = appState.allertAction{
                action()
            } else {
                print("no stored action")
            }
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
    
    static let quotationsurl = URL(string: serverLink + quotationsLink)!
    static let readsurl = URL(string: serverLink + readLink)!
    static let registerUrl = URL(string: serverLink + registerLink)!
    static let loginUrl = URL(string: serverLink + loginLink)!
}
