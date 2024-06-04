//
//  TextFieldWithWint.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 26.05.2024.
//

import UIKit

class TextFieldWithWint: UIView {
        
    public var textField: CustomTextField
    public let hintLabel = UILabel.textFieldHintLabel()
    
    init(type: CustomTextField.CustomTextFieldType, delegate: UITextFieldDelegate, returnKeyType: UIReturnKeyType) {
        self.textField = CustomTextField(type: type)
        super.init(frame: .zero)
        backgroundColor = .white
        textField.delegate = delegate
        textField.returnKeyType = returnKeyType
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        addSubview(hintLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(52)
        }
        
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(textField).inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    
}
