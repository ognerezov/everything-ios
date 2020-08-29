//
//  RecordType.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import UIKit

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
    
    var textModifficators : TextModifficators{
        switch self{
            case .chapter:
                return .h2
            default:
                return .p
        }
    }
    
    var textColorLight : UIColor{
        switch self{
            case .chapter:
                return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
            case .rule, .ruleBody:
                return UIColor.white
            default:
                return UIColor.black
        }
    }
    
    var textColorDark : UIColor{
        switch self{
            case .chapter:
                return UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
            case .rule, .ruleBody:
                return UIColor.black
            default:
                return UIColor.white
        }
    }
}
