//
//  Record.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

struct Record : Codable, Identifiable {
    var id : String = UUID().uuidString
    let number : Int
    let type : RecordType
    let spans : [Span]
    
    private enum CodingKeys: String, CodingKey {
        case type, number, spans
    }
}
