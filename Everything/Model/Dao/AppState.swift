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
    @Published var quotations : [Chapter] = []
    @Published var chapters : [Chapter] = []
    @Published var error : ErrorType = .NoException
    
    init() {
        user = User.user
        start()
        AppState.state = self
    }
    
    func start() {
        if (user.canRead){
            read()
        } else{
            fetchQuotations()
        }
    }
    
    func read(){
        print("start reading")
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
    
    func setAccessCode(_ accessCode: String){
        var request = URLRequest(url: readsurl)
        request.httpMethod = "POST"
        request.addValue(accessCode, forHTTPHeaderField: AppState.authorization)
        request.addValue(AppState.contentTypeJson, forHTTPHeaderField: AppState.contentType)
        let obj : BookRequest = BookRequest(numbers :[1])
        
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
                self.user.accessGranted(with: accessCode)
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
            appState.setAccessCode(accessCode)
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
