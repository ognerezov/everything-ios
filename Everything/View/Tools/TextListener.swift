//
//  TextListener.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 14.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import UIKit

class TextListener: NSObject, UITextFieldDelegate {
    var consumers : [String : TextConsumer] = [:]
    var receive : (_ val : String?) -> Void = {
        val in
        print("dummy :(")
        if let v = val{
            print(v)
        } else{
            print("empty value")
        }}
    
    func addConsumer(key: String, _ consumer: TextConsumer) {
        consumers[key] = consumer
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("edit")
        receive(textField.text)
        print(consumers.count)
        for consumer in consumers.values {
            consumer.receiveText(textField.text)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}
