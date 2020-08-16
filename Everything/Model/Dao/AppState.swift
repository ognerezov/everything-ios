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
    let quotationsurl = URL(string: "https://everything-from.one/free/quotations")!
    let readsurl = URL(string: "https://everything-from.one/book/read")!

    let session = URLSession(configuration : .default)
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    @Published var user : User
    @Published var settings : Settings
    @Published var quotations : [Chapter] = []
    @Published var chapters : [Chapter] = []
    @Published var error : ErrorType = .NoException
    
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

        cancelableQuotations = session.dataTaskPublisher(for: quotationsurl)
            .map({$0.data})
            .map{ data -> [Chapter] in
                do{
                    return try self.decoder.decode([Chapter].self, from:data)
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
        var request = URLRequest(url: readsurl)
        request.httpMethod = "POST"
        request.addValue(accessCode, forHTTPHeaderField: AppState.authorization)
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        let obj : BookRequest = BookRequest(numbers : numbers)
        
        do{
            request.httpBody = try encoder.encode(obj)
        }catch{
            print(error)
        }
        
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
                            chapters:  try self.decoder.decode([Chapter].self, from: response.data))
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
    
    static func setAccessCode(_ accessCode: String){
        if let appState = state{
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
}

//MARK: Literals

extension AppState{
    static let authorization = "Authorization"
    static let contentType = "Content-type"
    static let contentTypeJson = "application/json; charset=utf8"
}

//MARK: urls

extension AppState{

}
