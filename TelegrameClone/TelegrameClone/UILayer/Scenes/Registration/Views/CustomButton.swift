//
//  CustomButton.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit

class CustomButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = .systemBlue
        
        let titleColor: UIColor = .white
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.Roboto.regular.size(of: 19)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


