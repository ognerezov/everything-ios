//
//  RecordType.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

enum RecordType : String, Codable{
    case level
    case chapter
    case formula
    case rule
    case ruleBody = "rule body"
    case quotation
    case poem
    case regular
    case result
}
