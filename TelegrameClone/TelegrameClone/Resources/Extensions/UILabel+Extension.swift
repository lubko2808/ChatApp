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
