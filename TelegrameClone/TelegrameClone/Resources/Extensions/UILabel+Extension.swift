//
//  UILabel+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.05.2024.
//

import UIKit

extension UILabel {
    
    static func textFieldHintLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.Roboto.light.size(of: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
}

extension UILabel {

    func addRangeGesture(stringRange: String, action: @escaping () -> Void)  {
        self.isUserInteractionEnabled = true
        let tapGesture = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        tapGesture.stringRange = stringRange
        tapGesture.action = action
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }

    @objc func tappedOnLabel(_ gesture: RangeGestureRecognizer) {
        guard let text = self.text else { return }
        let stringRange = (text as NSString).range(of: gesture.stringRange ?? "")
        if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
            gesture.action?()
        }
    }
}

class RangeGestureRecognizer: UITapGestureRecognizer {
    var stringRange: String?
    var action: (() -> Void)?
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
      
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
      
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
