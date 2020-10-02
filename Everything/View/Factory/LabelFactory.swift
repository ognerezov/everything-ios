//
//  LabelFactory.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 31.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation
import UIKit

class LabelFactory {
    static let numberLight = UIColor(red: 0, green: 0.1, blue: 0.5, alpha: 1)
    static let numberDark = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1)
    
    static let backLight = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    static let backDark = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)


    static func label(content : [Span], width: CGFloat, isDark: Bool, type: RecordType,
                      fontSize : Int,  interactable : Bool = true) -> UILabel{
        let label = RecordLabel()
        label.set(content: content, width: width, isDark: isDark, type: type, fontSize: fontSize, interactable: interactable)
        return label
    }
}


