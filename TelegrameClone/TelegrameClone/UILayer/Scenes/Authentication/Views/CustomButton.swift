//
//  CustomButton.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit

class CustomButton: UIButton {
    
    private let background: UIColor
    public var isActive = false {
        didSet {
            isUserInteractionEnabled = isActive
            if isActive {
                self.backgroundColor = background
            } else {
                self.backgroundColor = .gray
            }
        }
    }
    
    init(title: String, background: UIColor = .systemBlue) {
        self.background = background
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        
        self.backgroundColor = background
        
        let titleColor: UIColor = .white
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.Roboto.regular.size(of: 19)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


