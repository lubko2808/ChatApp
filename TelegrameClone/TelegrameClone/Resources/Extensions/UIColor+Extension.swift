//
//  UIColor+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.06.2024.
//

import UIKit

extension UIColor {
    
    static func randomColor() -> UIColor {
        [.red, .green, .black, .blue, .darkGray, .purple, .systemPink].randomElement()!
    }
    
}
