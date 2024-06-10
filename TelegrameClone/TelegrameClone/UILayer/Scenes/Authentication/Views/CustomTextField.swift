//
//  CustomTextField.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case displayName
        case email
        case password
    }

    public var isTextFieldActive: Bool = false {
        didSet {
            isTextFieldActive == true ? movePlaceholder() : showPlaceholder()
        }
    }
    
    public var type: CustomTextFieldType
    private let borderView = UIView()
    private let placeholderLabel = UILabel()
    private var placeholderLabelCenterYConst: Constraint?
    private var placeholderLabelLeadingConst: Constraint?

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
        self.type = type
        super.init(frame: .zero)
        
        self.addSubview(borderView)
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = 15
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = AppColors.lightBlue.cgColor
        borderView.isUserInteractionEnabled = false
        
        borderView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
        
        self.font = UIFont.Roboto.regular.size(of: 17)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContentType = .oneTimeCode
        
        switch type {
        case .username:
            placeholderLabel.text = " Username "
        case .displayName:
            placeholderLabel.text = " Display Name "
        case .email:
            placeholderLabel.text = " Email Address "
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            placeholderLabel.text = " Password "
            self.isSecureTextEntry = true
        }
        
        placeholderLabel.textColor = .black
        placeholderLabel.backgroundColor = .white
        placeholderLabel.font = UIFont.Roboto.regular.size(of: 17)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let size = placeholderLabel.intrinsicContentSize
        self.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            placeholderLabelLeadingConst = make.leading.equalToSuperview().offset(15).constraint
            placeholderLabelCenterYConst = make.centerY.equalToSuperview().constraint
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPlaceholder() {
        guard self.text?.isEmpty == true else { return }
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.transform = .identity
            self.placeholderLabelCenterYConst?.update(offset: 0)
            self.placeholderLabelLeadingConst?.update(offset: 15)
            self.layoutIfNeeded()
        }
    }

    func movePlaceholder() {
        guard self.text?.isEmpty == true else { return }
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.placeholderLabelCenterYConst?.update(offset: -(self.bounds.height / 2.0))
            self.placeholderLabelLeadingConst?.update(offset: 0)
            self.layoutIfNeeded()
        }
    }
    
}


