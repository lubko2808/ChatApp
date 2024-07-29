//
//  ProfileSetupViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 26.05.2024.
//

import UIKit

class ProfileSetupViewController: BaseViewController {
    // MARK: - Properties
    private let viewOutput: ProfileSetupViewOutput
    private var validationOptions: ValidationOptions = .noneValid
    
    // MARK: - Views
    private lazy var displayNameInput = TextFieldWithWint(type: .displayName, delegate: self, returnKeyType: .continue)
    private lazy var usernameInput = TextFieldWithWint(type: .username, delegate: self, returnKeyType: .done)
    
    private let continueButton = CustomButton(title: "Continue")
    private let cancelButton = CustomButton(title: "Cancel", background: .red)
    
    // MARK: - Init
    init(viewOutput: ProfileSetupViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubviews(views: displayNameInput, usernameInput, continueButton, cancelButton)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        title = "Create Profile"
        let backButtonItem = UIBarButtonItem(image: UIImage.backButtonImage,
                                             style: .plain,
                                             target: navigationController,
                                             action: #selector(cancelButtonTapped))
        backButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setupConstraints() {
        
        displayNameInput.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(50)
        }
        
        usernameInput.snp.makeConstraints { make in
            make.top.equalTo(displayNameInput.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(50)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(usernameInput.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
    }
    
    // MARK: - Action handlers
    @objc private func continueButtonTapped() {
        
        displayNameInput.textField.resignFirstResponder()
        usernameInput.textField.resignFirstResponder()
        
        guard
            let displayName = displayNameInput.textField.text,
            let username = usernameInput.textField.text
        else { return }
        
        viewOutput.userDidTapContinueButton(displayName: displayName, username: username)
    }
    
    @objc private func cancelButtonTapped() {
        viewOutput.userDidTapCancelButton()
    }
    
}

// MARK: - UITextFieldDelegate
extension ProfileSetupViewController {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        guard let text = textField.text else { return }
        
        switch textField.type {
        case .displayName:
            viewOutput.userDidEnterDisplayName(text)
        case .username:
            viewOutput.userDidEnterUsername(text)
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == displayNameInput.textField {
            usernameInput.textField.becomeFirstResponder()
        } else if textField == usernameInput.textField {
            continueButtonTapped()
        }
        return true
    }
    
}

// MARK: - ViewInput
extension ProfileSetupViewController: ProfileSetupViewInput {
    func displayUsernameHint(_ hint: String?) {
        displayHint(hint, on: usernameInput.hintLabel, userInfoOption: .usernameValid)
    }
    
    func displayDisplayNameHint(_ hint: String?) {
        displayHint(hint, on: displayNameInput.hintLabel, userInfoOption: .displayNameValid)
    }

    private func displayHint(_ hint: String?, on label: UILabel, userInfoOption: ValidationOptions) {
        if hint == nil {
            validationOptions.insert(userInfoOption)
        } else {
            validationOptions.remove(userInfoOption)
        }
        
        if validationOptions == .profileValid {
            continueButton.isActive = true
        } else {
            continueButton.isActive = false
        }
        
        guard let hint else {
            label.text = ""
            return
        }
        label.text = hint
        label.textColor = .red
    }
    
}
