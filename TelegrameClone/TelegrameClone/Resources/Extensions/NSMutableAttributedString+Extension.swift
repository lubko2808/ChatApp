//
//  NSMutableAttributedString+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 08.06.2024.
//

import UIKit

extension NSMutableAttributedString {
    
    static func textWithHiglightes(text: String, highlightedText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let highlightedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemMint]
        if let range = text.range(of: highlightedText) {
             let nsRange = NSRange(range, in: text)
             attributedString.addAttributes(highlightedAttributes, range: nsRange)
        }
        return attributedString
    }
    
}
