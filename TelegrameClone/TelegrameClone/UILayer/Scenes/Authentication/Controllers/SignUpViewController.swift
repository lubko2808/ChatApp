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
    
    // MARK: - Views
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var displayNameInput = TextFieldWithWint(type: .displayName, delegate: self, returnKeyType: .continue)
    private lazy var usernameInput = TextFieldWithWint(type: .username, delegate: self, returnKeyType: .continue)
    private lazy var emailInput = TextFieldWithWint(type: .email, delegate: self, returnKeyType: .continue)
    private lazy var passwordInput = TextFieldWithWint(type: .password, delegate: self, returnKeyType: .done)

    private let signUpButton = CustomButton(title: "Sign Up")
    
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
        title = "Sign up"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)

        signUpButton.isActive = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubviews(views: contentView, displayNameInput, usernameInput, emailInput, passwordInput, signUpButton)
        
        view.addSubview(loaderContainer)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loader)
        
        displayNameInput.textField.tag = 1
        usernameInput.textField.tag = 2
        emailInput.textField.tag = 3
        passwordInput.textField.tag = 4
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

        displayNameInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.top).offset(300)
            make.width.equalToSuperview().inset(50)
        }
        
        usernameInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(displayNameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(50)
        }
        
        emailInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameInput.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(50)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailInput.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordInput.snp.bottom).offset(10)
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
    
    @objc private func signUpButtonTapped() {
    
        emailInput.textField.resignFirstResponder()
        passwordInput.textField.resignFirstResponder()
        displayNameInput.textField.resignFirstResponder()
        usernameInput.textField.resignFirstResponder()
        
        guard
            let displayName = displayNameInput.textField.text,
            let username = usernameInput.textField.text,
            let email = emailInput.textField.text,
            let password = passwordInput.textField.text
        else { return }
        
        viewOutput.userDidTapSignUpButton(displayName: displayName, username: username, email: email, password: password)
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
        if textField === passwordInput.textField {
            signUpButtonTapped()
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
        displayHint(hint, on: displayNameInput.hintLabel, userInfoOption: .displayNameValid)
    }
    
    func displayUsernameHint(_ hint: String?) {
        displayHint(hint, on: usernameInput.hintLabel, userInfoOption: .usernameValid)
    }
    
    func displayEmailHint(_ hint: String?) {
        displayHint(hint, on: emailInput.hintLabel, userInfoOption: .emailValid)
    }
    
    func displayPasswordHint(_ hint: String?) {
        displayHint(hint, on: passwordInput.hintLabel, userInfoOption: .passwordValid)
    }
    
    private func displayHint(_ hint: String?, on label: UILabel, userInfoOption: ValidationOptions) {
        if hint == nil {
            validationOptions.insert(userInfoOption)
        } else {
            validationOptions.remove(userInfoOption)
        }
        
        if validationOptions == .signUpValid {
            signUpButton.isActive = true
        } else {
            signUpButton.isActive = false
        }
        
        guard let hint else {
            label.text = ""
            return
        }
        label.text = hint
        label.textColor = .red
    }
    
}
