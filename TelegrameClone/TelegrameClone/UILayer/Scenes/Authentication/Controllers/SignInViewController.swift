//
//  LoginViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
        
    // MARK: - Properties
    private var isKeyboardShown = false
    var imageViewTopConstraint: Constraint?
    private let viewOutput: SignInViewOutput
    private var validationOptions: ValidationOptions = .noneValid
    
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
    
    private let emailHintLabel = UILabel.textFieldHintLabel()
    
    private let passwordTextField: CustomTextField = {
        let field = CustomTextField(type: .password)
        field.returnKeyType = .done
        return field
    }()
    
    private let passwordHintLabel = UILabel.textFieldHintLabel()
    
    lazy private var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInButton: CustomButton = CustomButton(title: "Log in")
    
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
        setupObservers()
    }
    
    deinit {
        stopKeyboardListener()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "Log in"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubviews(views: imageView, emailTextField, emailHintLabel,
                         passwordTextField, passwordHintLabel, forgotPasswordButton,
                         signInButton, loaderContainer, loader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.isActive = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        emailHintLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(emailTextField).inset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailHintLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        passwordHintLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(passwordTextField).inset(10)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordHintLabel.snp.bottom).offset(5)
            make.trailing.equalTo(passwordTextField)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        loaderContainer.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Action handlers
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    @objc private func signInButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        viewOutput.userDidTapSignInButton(email: email, password: password)
    }
    
    @objc private func forgotPasswordButtonTapped() {
        viewOutput.userDidTapForgotPassword()
    }
    
    @objc private func didTapRegister() {
//        let vc = SignUpViewController()
//        vc.title = "Create Account"
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private var isPasswordValid = false
    private var isEmailValid = false

}

// MARK: - ViewInput
extension SignInViewController: SignInViewInput {
    
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
extension SignInViewController: UITextFieldDelegate {

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
        case .email:
            viewOutput.userDidEnterEmail(text)
        case .password:
            viewOutput.userDidEnterPassword(text)
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            signInButtonTapped()
        }
        return true
    }
    
}

// MARK: - Keyboard Observers
private extension SignInViewController {
    func setupObservers() {
        startKeyboardListener()
    }
    func startKeyboardListener() {
        print("startKeyboardListener")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopKeyboardListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        print(keyboardFrame.height)
        if !isKeyboardShown {
            
            let fromCoordinateSpace = screen.coordinateSpace
            let toCoordinateSpace: UICoordinateSpace = self.signInButton.coordinateSpace
            let convertedKeyboardFrame = fromCoordinateSpace.convert(keyboardFrame, to: toCoordinateSpace)
            let viewIntersection = self.signInButton.bounds.intersection(convertedKeyboardFrame)
            print(viewIntersection.height)
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


