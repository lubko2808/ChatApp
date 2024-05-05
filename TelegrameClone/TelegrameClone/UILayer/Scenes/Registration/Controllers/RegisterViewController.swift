//
//  RegisterViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Views
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let displayNameTextField: CustomTextField = {
        let field = CustomTextField(type: .displayName)
        field.returnKeyType = .continue
        field.tag = 1
        return field
    }()
    
    private let userNameTextField: CustomTextField = {
        let field = CustomTextField(type: .username)
        field.returnKeyType = .continue
        field.tag = 2
        return field
    }()

    private let emailTextField: CustomTextField = {
        let field = CustomTextField(type: .email)
        field.returnKeyType = .continue
        field.tag = 3
        return field
    }()

    private let passwordTextField: CustomTextField = {
        let field = CustomTextField(type: .password)
        field.returnKeyType = .done
        field.tag = 4
        return field
    }()
    
    private let registerButton = CustomButton(title: "Register")
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "Log in"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        registerButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(displayNameTextField)
        contentView.addSubview(userNameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(registerButton)
        
        displayNameTextField.delegate = self
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(scrollView.snp.height).priority(1)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }

        displayNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.top).offset(300)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(displayNameTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Action handlers
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    @objc private func registrationButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        
        guard
            let firstName = displayNameTextField.text,
            let lastName = userNameTextField.text,
            let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        // Firebase Log in
        
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to create a new account", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        if textField === passwordTextField {
            registrationButtonTapped()
        } else if let nextTextField = view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        }

        return true

    }
    
}
