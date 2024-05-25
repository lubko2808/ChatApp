//
//  UIView+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
}
