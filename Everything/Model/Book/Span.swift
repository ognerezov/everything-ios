//
//  Span.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

struct Span : Codable,Identifiable {
    var id : String = UUID().uuidString
    
    let text : String
    let number : Bool
    
    private enum CodingKeys: String, CodingKey {
        case text, number
    }
}
