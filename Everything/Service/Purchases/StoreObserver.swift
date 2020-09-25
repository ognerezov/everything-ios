//
//  StoreObserver.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 24/09/2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import StoreKit

class  StoreObserver: NSObject, SKProductsRequestDelegate{
    var products : [SKProduct] = []
    var ids : Set<String> = ["everything_reader_access"]
    var productAvailable : Bool{
        products.count > 0
    }
    
    override init() {
        super.init()
        request()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        print("found \(products.count) products")
    }
    
    func request() {
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    
}
