//
//  Chapter.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

typealias Book = [Int : Character]

struct Chapter : Codable, Identifiable{
    var id : Int {
        return number
    }
    let number : Int
    let type : RecordType
    let level : Int
    let records : [Record]
}
