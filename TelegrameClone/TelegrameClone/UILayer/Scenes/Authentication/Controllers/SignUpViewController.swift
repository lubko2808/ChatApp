//
//  RegisterViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit
import RxSwift
import FirebaseStorage
import SnapKit

class SignUpViewController: BaseViewController {
        
    // MARK: - Properties
    private let viewOutput: SignUpViewOutput
    var validationOptions: ValidationOptions = .noneValid
    private let bag = DisposeBag()
    private var displayNameInputTopConstraint: Constraint?
    private var isKeyboardShown = false
    
    private enum UIConstants {
        static let distanceFromDisplayNameInputToViewTop: CGFloat = 150
    }
    
    // MARK: - Views

    private lazy var displayNameInput = TextFieldWithWint(type: .displayName, delegate: self, returnKeyType: .continue)
    private lazy var usernameInput = TextFieldWithWint(type: .username, delegate: self, returnKeyType: .continue)
    private lazy var emailInput = TextFieldWithWint(type: .email, delegate: self, returnKeyType: .continue)
    private lazy var passwordInput = TextFieldWithWint(type: .password, delegate: self, returnKeyType: .done)

    private let signUpButton = CustomButton(title: "Sign Up")
    
    private let loginButtonsView = LoginButtonsView(title: "Or Register With")
    
    private lazy var alreadyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString.textWithHiglightes(text: "Already have an account? Login now", highlightedText: "Login now")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addRangeGesture(stringRange: "Login now") { [weak self] in
            self?.viewOutput.userDidTapLogin()
        }        
        return label
    }()
    
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
        super.addLoader()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "Sign up"
        
        signUpButton.isActive = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        view.addSubviews(views: displayNameInput, usernameInput, emailInput, passwordInput, signUpButton, loginButtonsView, alreadyHaveAccountLabel)

        loginButtonsView.appleButtonTapped
            .subscribe { [weak self] sender in
                self?.appleButtonTapped(sender)
            }
            .disposed(by: bag)
        
        loginButtonsView.googleButtonTapped
            .subscribe { [weak self] sender in
                self?.googleButtonTapped(sender)
            }
            .disposed(by: bag)
        
        loginButtonsView.facebookButtonTapped
            .subscribe { [weak self] sender in
                self?.facebookButtonTapped(sender)
            }
            .disposed(by: bag)
        
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

        displayNameInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            displayNameInputTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide).offset(UIConstants.distanceFromDisplayNameInputToViewTop).constraint
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
        }
        
        loginButtonsView.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(35)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
    }
    
    // MARK: - Action handlers
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
    
    private func googleButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignUpWithGoogle()
        }
    }
    
    private func appleButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignUpWithApple()
        }
    }
    
    private func facebookButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignUpWithFacebook()
        }
    }
    
    // MARK: - Keyboard
    override func keyboardWillShow(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        if !isKeyboardShown {
            let fromCoordinateSpace = screen.coordinateSpace
            let toCoordinateSpace: UICoordinateSpace = self.signUpButton.coordinateSpace
            let convertedKeyboardFrame = fromCoordinateSpace.convert(keyboardFrame, to: toCoordinateSpace)
            let viewIntersection = self.signUpButton.bounds.intersection(convertedKeyboardFrame)
            if (viewIntersection.height == 0) { return }
            UIView.animate(withDuration: 0.3) {
                self.displayNameInputTopConstraint?.update(offset: 20)
                self.view.layoutIfNeeded()
                self.isKeyboardShown = true
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.displayNameInputTopConstraint?.update(offset: UIConstants.distanceFromDisplayNameInputToViewTop)
            self.isKeyboardShown = false
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UITextFieldDelegate
extension SignUpViewController {

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
