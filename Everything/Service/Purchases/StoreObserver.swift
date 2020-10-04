//
//  StoreObserver.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 24/09/2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import StoreKit

class  StoreObserver: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    var owner : AppState?
    var products : [SKProduct] = []
    var ids : Set<String> = ["everything_reader_access"]
    var paymentQueue = SKPaymentQueue.default()
    
    var productAvailable : Bool{
        products.count > 0
    }
    
    override init() {
        super.init()
        paymentQueue.add(self)
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
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased, .restored:
                    if let receipt = loadReceipt(){
                        //print(receipt)
                        AppState.verifyReceipt(receipt: receipt){
                            self.paymentQueue.finishTransaction(transaction as! SKPaymentTransaction)
                            print("purchased")
                        }
                    } else{
                        print("receipt not found")
                    }
                    break
                    
                case .failed:
                    paymentQueue.finishTransaction(transaction as! SKPaymentTransaction)
                    print("Payment has failed.")
                    break
//                case .restored:
//                    paymentQueue.finishTransaction(transaction as! SKPaymentTransaction)
//                    print("Purchase has been successfully restored!")
//                    break
                    
                default: break
        }}}
    }
    
    func loadReceipt() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
//                print(String(decoding: receiptData, as: UTF8.self))

                return receiptData.base64EncodedString(options: [])

            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription)
                return nil
            }
        }
        print("File not found \(String(describing: Bundle.main.appStoreReceiptURL)) ")
        return nil
    }
    
    func purchase() {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            let payment = SKPayment(product: products[0])
            paymentQueue.add(payment)
        } else { print("Purchases are disabled in your device!") }
    }
    
}
