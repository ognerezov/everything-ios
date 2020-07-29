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
    let url = URL(string: "https://everything-from.one/free/quotations")!
    let session = URLSession(configuration : .default)
    let decoder = JSONDecoder()
    
    @Published var user : User
    @Published var quotations : [Chapter] = []
    
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

        cancelableQuotations = session.dataTaskPublisher(for: url)
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
                    print($0)
            })
    
    }
}

/*
    Singleton
 */
extension AppState{
    static var state : AppState?
    static func refreshQuotations(){
        if let appState = state{
            appState.quotations = []
            appState.fetchQuotations()
        }
    }
}
