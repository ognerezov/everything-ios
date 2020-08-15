//
//  TextModifficators.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 15.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import UIKit

enum TextModifficators : CGFloat {
    case p = 0
    case h1 = 5
    case h2 = 3
    case h3 = 1
    
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
}
