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

    static func label(content : [Span], width: CGFloat, isDark: Bool, type: RecordType) -> UILabel{
        var clickChars : [Int:Int] = [:]
        let text : NSMutableAttributedString = content.reduce(NSMutableAttributedString(), {
                text , span in
            let start = text.length
            text.append(NSAttributedString(string: span.text))
            let end = text.length
            let range = NSMakeRange(start,end - start)

            if(span.number && end > start){
                for i in start - 1 ... end{
                    clickChars [i] = Int(span.text)
                }
                text.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0 + type.textModifficators.rawValue ,weight: type.textModifficators.numberFontWeight), range: range)
            } else{
                text.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0 + type.textModifficators.rawValue,weight: type.textModifficators.fontWeight), range: range)
            }
            text.addAttribute(.foregroundColor, value: isDark ? type.textColorDark: type.textColorLight, range: range)
            return text
        })
        
        let label = VerticalTopAlignLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        
        label.attributedText = text
        label.isUserInteractionEnabled = true
        label.listener = NumberTapDelegate(charMap: clickChars)
        label.addGestureRecognizer(UITapGestureRecognizer(target:label, action: #selector(VerticalTopAlignLabel.tapLabel(gesture:))))
        return label
    }
}

/*
     let label = UITextView()
     label.isEditable = false
     label.isSelectable = true
     var frame = label.frame;
     frame.size.height = label.contentSize.height;
     label.frame = frame;
 
 text.addAttribute(.backgroundColor, value: isDark ? UIColor.systemBlue : UIColor.systemTeal, range: range1)
 text.addAttribute( .underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range1)
 */


