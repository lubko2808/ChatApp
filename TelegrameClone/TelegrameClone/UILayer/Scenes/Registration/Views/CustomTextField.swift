//
//  CustomTextField.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case displayName
        case email
        case password
    }
    
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    init(type: CustomTextFieldType) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.backgroundColor = AppColors.lightGray
        self.font = UIFont.Roboto.regular.size(of: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContentType = .oneTimeCode
        
        switch type {
        case .username:
            self.placeholder = "Username"
        case .displayName:
            self.placeholder = "Display Name"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.isSecureTextEntry = true
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

