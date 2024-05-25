//
//  RegisterViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit

class SignUpViewController: UIViewController {
        
    // MARK: - Properties
    private let viewOutput: SignUpViewOutput
    var validationOptions: ValidationOptions = .noneValid
    
    enum Constants {
        static let distanceFromHintToTextField: CGFloat = 5
        static let distanceFromTextFieldToHint: CGFloat = 10
    }

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
    
    private let displayNameHintLabel = UILabel.textFieldHintLabel()
    
    private let userNameTextField: CustomTextField = {
        let field = CustomTextField(type: .username)
        field.returnKeyType = .continue
        field.tag = 2
        return field
    }()
    
    private let userNameHintLabel = UILabel.textFieldHintLabel()

    private let emailTextField: CustomTextField = {
        let field = CustomTextField(type: .email)
        field.returnKeyType = .continue
        field.tag = 3
        return field
    }()
    
    private let emailHintLabel = UILabel.textFieldHintLabel()

    private let passwordTextField: CustomTextField = {
        let field = CustomTextField(type: .password)
        field.returnKeyType = .done
        field.tag = 4
        return field
    }()
    
    private let passwordHintLabel = UILabel.textFieldHintLabel()
    
    private let registerButton = CustomButton(title: "Register")
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let loaderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    private let loader = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    init(viewOutput: SignUpViewOutput) {
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
    
    // MARK: - setup
    private func setupViews() {
        title = "Log in"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        registerButton.isActive = false
        registerButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubviews(views: contentView, displayNameTextField, displayNameHintLabel,
                               userNameTextField, userNameHintLabel, emailTextField, emailHintLabel,
                               passwordTextField, passwordHintLabel, registerButton)
        
        displayNameTextField.delegate = self
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(loaderContainer)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loader)
    }
    
    private func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: UIImage.backButtonImage,
                                             style: .plain,
                                             target: navigationController,
                                             action: #selector(navigationController?.popViewController(animated:)))
        backButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = backButtonItem
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
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        displayNameHintLabel.snp.makeConstraints { make in
            make.top.equalTo(displayNameTextField.snp.bottom).offset(Constants.distanceFromHintToTextField)
            make.centerX.equalToSuperview()
            make.width.equalTo(displayNameTextField).inset(10)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(displayNameHintLabel.snp.bottom).offset(Constants.distanceFromTextFieldToHint)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        userNameHintLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(Constants.distanceFromHintToTextField)
            make.centerX.equalToSuperview()
            make.width.equalTo(userNameTextField).inset(10)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameHintLabel.snp.bottom).offset(Constants.distanceFromTextFieldToHint)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        emailHintLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Constants.distanceFromHintToTextField)
            make.centerX.equalToSuperview()
            make.width.equalTo(emailTextField).inset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailHintLabel.snp.bottom).offset(Constants.distanceFromTextFieldToHint)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        passwordHintLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.distanceFromHintToTextField)
            make.centerX.equalToSuperview()
            make.width.equalTo(passwordTextField).inset(10)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordHintLabel.snp.bottom).offset(Constants.distanceFromTextFieldToHint)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
        
        loaderContainer.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        
    }
    
    // MARK: - Action handlers
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    @objc private func registrationButtonTapped() {
        print("registrationButtonTapped")
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        
        guard
            let displayName = displayNameTextField.text,
            let username = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text 
        else { return }
        
        viewOutput.userDidTapSignUpButton(displayName: displayName, username: username, email: email, password: password)
    }
    
    @objc private func didTapRegister() {
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        guard let text = textField.text else { return }
        
        switch textField.type {
        case .username:
            viewOutput.userDidEnterUsername(text)
        case .displayName:
            viewOutput.userDidEnterDisplayName(text)
        case .email:
            viewOutput.userDidEnterEmail(text)
        case .password:
            viewOutput.userDidEnterPassword(text)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === passwordTextField {
            registrationButtonTapped()
        } else if let nextTextField = view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        }

        return true
    }
}

// MARK: - ViewInput
extension SignUpViewController: SignUpViewInput {
    
    func startLoader() {
        loaderContainer.isHidden = false
        loader.startAnimating()
    }
    
    func stopLoader() {
        loaderContainer.isHidden = true
        loader.stopAnimating()
    }
    
    func displayError(with message: String) {
        self.displayAlert(with: message)
    }
    
    func displayDisplayNameHint(_ hint: String?) {
        displayHint(hint, on: displayNameHintLabel, userInfoOption: .displayNameValid)
    }
    
    func displayUsernameHint(_ hint: String?) {
        displayHint(hint, on: userNameHintLabel, userInfoOption: .usernameValid)
    }
    
    func displayEmailHint(_ hint: String?) {
        displayHint(hint, on: emailHintLabel, userInfoOption: .emailValid)
    }
    
    func displayPasswordHint(_ hint: String?) {
        displayHint(hint, on: passwordHintLabel, userInfoOption: .passwordValid)
    }
    
    private func displayHint(_ hint: String?, on label: UILabel, userInfoOption: ValidationOptions) {
        if hint == nil {
            validationOptions.insert(userInfoOption)
        } else {
            validationOptions.remove(userInfoOption)
        }
        
        if validationOptions == .signUpValid {
            registerButton.isActive = true
        } else {
            registerButton.isActive = false
        }
        
        guard let hint else {
            label.text = ""
            return
        }
        label.text = hint
        label.textColor = .red
    }
    
}
