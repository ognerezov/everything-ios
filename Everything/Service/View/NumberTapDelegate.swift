//
//  NumberTapDelegate.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 15.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

struct NumberTapDelegate: CharacterListener{
    var charMap : [Int:Int]
    
    func tap(at position: Int) {
        if let value = charMap[position]{
            print("number is " + String(value))
            AppState.add(number: value)
        } else{
            print("taped outside")
            print(charMap)
        }
    }
}
