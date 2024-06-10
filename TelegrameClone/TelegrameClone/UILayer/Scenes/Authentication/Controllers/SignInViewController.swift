//
//  LoginViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit
import SnapKit
import FacebookLogin
import RxSwift

final class SignInViewController: AuthBaseViewController {
        
    // MARK: - Properties
    private var isKeyboardShown = false
    private var imageViewTopConstraint: Constraint?
    private let viewOutput: SignInViewOutput
    private var validationOptions: ValidationOptions = .noneValid
    
    private enum Constants {
        static let distanceFromImageViewToViewTop: CGFloat = 120
    }
    
    private let bag = DisposeBag()
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .logoSvg)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emailInput = TextFieldWithWint(type: .email, delegate: self, returnKeyType: .continue)
    private lazy var passwordInput = TextFieldWithWint(type: .password, delegate: self, returnKeyType: .done)
    
    lazy private var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        
        let loginButton = FBLoginButton()
        return button
    }()
    
    private lazy var signInButton: CustomButton = {
        let button = CustomButton(title: "Log in")
        button.isActive = false
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let loginButtonsView = LoginButtonsView(title: "Or Login with")

    private lazy var dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString.textWithHiglightes(text: "Don't have an account? Register now", highlightedText: "Register now")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addRangeGesture(stringRange: "Register now") { [weak self] in
            self?.viewOutput.userDidTapRegister()
        }
        return label
    }()
    
    // MARK: - Init
    init(viewOutput: SignInViewOutput) {
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
        title = "Sign in"

        view.addSubviews(views: imageView, emailInput,
                         passwordInput, forgotPasswordButton,
                         signInButton, loginButtonsView, dontHaveAccountLabel)
        
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
        
        imageView.snp.makeConstraints { make in
            imageViewTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.distanceFromImageViewToViewTop).constraint
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emailInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(50)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailInput.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(50)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInput.snp.bottom).offset(5)
            make.trailing.equalTo(passwordInput)
        }

        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        loginButtonsView.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(35)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
        
        dontHaveAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }
    
    // MARK: - Action handlers
    
    @objc private func signInButtonTapped() {

        emailInput.textField.resignFirstResponder()
        passwordInput.textField.resignFirstResponder()
        
        guard let email = emailInput.textField.text, let password = passwordInput.textField.text else {
            return
        }
        
        viewOutput.userDidTapSignInButton(email: email, password: password)
    }
    
    @objc private func forgotPasswordButtonTapped() {
        viewOutput.userDidTapForgotPassword()
    }
    
    private func googleButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignInWithGoogle()
        }
    }
    
    private func appleButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignInWithApple()
        }
    }
    
    private func facebookButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignInWithFacebook()
        }
    }
    
    // MARK: - Keyboard
    override func keyboardWillShow(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        print(keyboardFrame.height)
        if !isKeyboardShown {
            let fromCoordinateSpace = screen.coordinateSpace
            let toCoordinateSpace: UICoordinateSpace = self.signInButton.coordinateSpace
            let convertedKeyboardFrame = fromCoordinateSpace.convert(keyboardFrame, to: toCoordinateSpace)
            let viewIntersection = self.signInButton.bounds.intersection(convertedKeyboardFrame)
            if (viewIntersection.height == 0) { return }
            UIView.animate(withDuration: 0.3) {
                self.imageViewTopConstraint?.update(offset: Constants.distanceFromImageViewToViewTop - Constants.distanceFromImageViewToViewTop / (1.5))
                self.view.layoutIfNeeded()
                self.isKeyboardShown = true
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.imageViewTopConstraint?.update(offset: Constants.distanceFromImageViewToViewTop)
            self.isKeyboardShown = false
            self.view.layoutIfNeeded()
        }
    }


}

// MARK: - ViewInput
extension SignInViewController: SignInViewInput {

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
        
        if validationOptions == .signInValid {
            signInButton.isActive = true
        } else {
            signInButton.isActive = false
        }
        
        guard let hint else {
            label.text = ""
            return
        }
        label.text = hint
        label.textColor = .red
    }
    
}

// MARK: - UITextFieldDelegate
extension SignInViewController {  

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        guard let text = textField.text else { return }
        
        switch textField.type {
        case .email:
            viewOutput.userDidEnterEmail(text)
        case .password:
            viewOutput.userDidEnterPassword(text)
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailInput.textField {
            passwordInput.textField.becomeFirstResponder()
        } else if textField == passwordInput.textField {
            signInButtonTapped()
        }
        return true
    }
    
}

