//
//  LoginViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import Foundation

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var isKeyboardShown = false
    var imageViewTopConstraint: Constraint?
    
    enum Constants {
        static let distanceFromImageViewToViewTop: CGFloat = 120
    }
    
    // MARK: - Views

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .logoSvg)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emailTextField: CustomTextField = {
        let field = CustomTextField(type: .email)
        field.returnKeyType = .continue
        return field
    }()
    
    private let passwordTextField: CustomTextField = {
        let field = CustomTextField(type: .password)
        field.returnKeyType = .done
        return field
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "Log in")
        return button
    }()
    
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
        setupObservers()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "Log in"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        imageView.snp.makeConstraints { make in
            imageViewTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.distanceFromImageViewToViewTop).constraint
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(52)
        }
    }
    
    // MARK: - Action handlers
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    @objc private func loginButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        // Firebase Log in
        
    }
    
    @objc private func didTapRegister() {
        
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        present(alert, animated: true)
    }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
    
}

// MARK: - Keyboard Observers
private extension LoginViewController {
    func setupObservers() {
        startKeyboardListener()
    }
    func startKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopKeyboardListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if !isKeyboardShown {
            
            let fromCoordinateSpace = screen.coordinateSpace
            let toCoordinateSpace: UICoordinateSpace = self.loginButton.coordinateSpace
            let convertedKeyboardFrame = fromCoordinateSpace.convert(keyboardFrame, to: toCoordinateSpace)
            let viewIntersection = self.loginButton.bounds.intersection(convertedKeyboardFrame)
            UIView.animate(withDuration: 0.3) {
                let padding: CGFloat = 10
                self.imageViewTopConstraint?.update(offset: Constants.distanceFromImageViewToViewTop - viewIntersection.height - padding)
                self.view.layoutIfNeeded()
                self.isKeyboardShown = true
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.imageViewTopConstraint?.update(offset: Constants.distanceFromImageViewToViewTop)
            self.isKeyboardShown = false
            self.view.layoutIfNeeded()
        }
    }
}
