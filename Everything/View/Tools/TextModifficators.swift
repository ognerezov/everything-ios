//
//  TextModifficators.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 15.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import UIKit

enum TextModifficators : CGFloat {
    case q = -0.2
    case p = 0
    case p1 = 0.2
    case h1 = 4
    case h2 = 1
    case h3 = 0.25
    
    var size : CGFloat{
        switch self{
        case .q, .p, .p1:
                return 0
            default:
                return rawValue
        }
    }
    
    var fontWeight : UIFont.Weight{
        switch self {
        case .h1,
             .h2,
             .h3:
            return .medium
        default:
            return .regular
        }
    }
    
    var numberFontWeight : UIFont.Weight{
        switch self {
        case .h1,
             .h2,
             .h3:
            return .bold
        default:
            return .semibold
        }
    }
    
    func fontName(for family: String, isNumber: Bool) -> String?{
        switch family {
        case "HelveticaNeue":
            switch self {
            case .h2:
                return "HelveticaNeue-CondensedBlack"
            case .h1:
                return "HelveticaNeue-Bold"
            case .h3:
                return "HelveticaNeue-BoldItalic"
            case .p1:
                return "HelveticaNeue-Italic"
            case .q:
                return
                    "HelveticaNeue-Italic"
            default:
                return
                    "HelveticaNeue-Light"
            }
            
        default:
            return nil
        }
    }
}
