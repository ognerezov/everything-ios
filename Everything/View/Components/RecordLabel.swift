//
//  VerticalTopAlignLabel.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 31.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import UIKit

class RecordLabel: UILabel {
    var content : [Span] = []
    var width: CGFloat = 0
    var isDark: Bool = false
    var type: RecordType = .regular
    var fontSize : Int = 16
    var interactable : Bool = true
    
    
    var listener : CharacterListener?
    
    func set(content : [Span], width: CGFloat, isDark: Bool, type: RecordType,
             fontSize : Int,  interactable : Bool = true) {
        self.content = content
        self.width = width
        self.isDark = isDark
        self.type = type
        self.fontSize = fontSize
        self.interactable = interactable
        prepare()
    }
    
    func set(isDark: Bool, fontSize : Int){
        self.isDark = isDark
        self.fontSize = fontSize
        prepare()
    }
    
    func prepare(){
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
                text.addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize) + type.textModifficators.rawValue ,weight: type.textModifficators.numberFontWeight), range: range)
            } else{
                text.addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize) + type.textModifficators.rawValue,weight: type.textModifficators.fontWeight), range: range)
            }
            text.addAttribute(.foregroundColor, value: isDark ? type.textColorDark: type.textColorLight, range: range)
            return text
        })
        
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        preferredMaxLayoutWidth = width
        
        attributedText = text
        if interactable {
            isUserInteractionEnabled = true
            listener = NumberTapDelegate(charMap: clickChars)
            addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(RecordLabel.tapLabel(gesture:))))
        }
    }
    


    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font!])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        print("taped text" + text!)
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        let labelSize = bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = gesture.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
          print("taped text at position: " + String(indexOfCharacter))
        if let delegate = listener{
            delegate.tap(at: indexOfCharacter)
        }
    }
}
