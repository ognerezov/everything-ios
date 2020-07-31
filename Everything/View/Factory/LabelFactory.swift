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
    static func label(content : [Span], width: CGFloat) -> UILabel{
        let text : NSMutableAttributedString = content.reduce(NSMutableAttributedString(), {
                text , span in
            let start = text.length
            text.append(NSAttributedString(string: span.text))
            let end = text.length
            let range1 = NSMakeRange(start,end - start)

            if(span.number && end > start){
                text.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0,weight: .heavy), range: range1)
                text.addAttribute(.backgroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: range1)
                text.addAttribute(.foregroundColor, value: UIColor.white, range: range1)
            }
            return text
        })
        
        let label = VerticalTopAlignLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.attributedText = text
        return label
    }
}
