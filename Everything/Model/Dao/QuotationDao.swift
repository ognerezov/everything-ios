//
//  QuotationDao.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import Combine

class Quoutations : ObservableObject {
    let url = URL(string: "https://everything-from.one/free/quotations")!
    let session = URLSession(configuration : .default)
    let decoder = JSONDecoder()
    @Published var quotations : [Chapter] = []
    
    var cancelable : AnyCancellable?
    
    func fetchPublish()   {

        cancelable = session.dataTaskPublisher(for: url)
            .map({$0.data})
            .map{ data -> [Chapter] in
                do{
                    return try self.decoder.decode([Chapter].self, from:data)
                }catch{
                    return[]
                }
                
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {print($0)},
                  receiveValue:{self.quotations = $0})
    
    }
}
