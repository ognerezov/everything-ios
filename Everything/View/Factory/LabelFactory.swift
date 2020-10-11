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

    static func label(content : [Span], width: CGFloat, isDark: Bool, type: RecordType,
                      fontSize : Int,  interactable : Bool = true) -> UILabel{
        let label = RecordLabel()
        label.set(content: content, width: width, isDark: isDark, type: type, fontSize: fontSize, interactable: interactable)
        return label
    }
}


