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
            case .level:
                return .h1
            case .chapter:
                return .h2
            case .formula:
                return .h3
            case .poem, .quotation:
                return .q
            case .rule, .ruleBody:
                return .p1
            default:
                return .p
        }
    }
    
    
    var textColorLight : UIColor{
        return UIColor.black
//        switch self{
//            case .chapter:
//                return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
//            case .rule, .ruleBody:
//                return UIColor.white
//            default:
//                return UIColor.black
//        }
    }
    
    var textColorDark : UIColor{
        return UIColor.white
//        switch self{
//            case .chapter:
//                return UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
//            case .rule, .ruleBody:
//                return UIColor.black
//            default:
//                return UIColor.white
//        }
    }
}
