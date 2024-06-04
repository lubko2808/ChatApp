//
//  LoginViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 05.05.2024.
//

import UIKit
import SnapKit
import FacebookLogin

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
    
    private let dividerView = DividerView(title: "Or Login with")
    
    private let googleButton = RegistrationButton(type: .google)
    private let appleButton = RegistrationButton(type: .apple)
    private let facebookButton = RegistrationButton(type: .facebook)
    
    private let loginButtonsView = LoginButtonsView(title: "Or Login with")

    private lazy var dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        let text = "Don't have an account? Register now"
        let attributedString = NSMutableAttributedString(string: text)
        let highlightedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemMint]
        if let range = text.range(of: "Register now") {
             let nsRange = NSRange(range, in: text)
             attributedString.addAttributes(highlightedAttributes, range: nsRange)
         }
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addRangeGesture(stringRange: "Register now") { [weak self] in
            self?.viewOutput.userDidTapRegister()
        }
        return label
    }()
    
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
        title = "Sign in"
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)

        view.addSubviews(views: imageView, emailInput,
                         passwordInput, forgotPasswordButton,
                         signInButton, loginButtonsView, dontHaveAccountLabel, loaderContainer, loader)
        
        loginButtonsView.onAppleButtonTap = { [weak self] sender in
            self?.appleButtonTapped(sender)
        }
        loginButtonsView.onGoogleButtonTap = { [weak self] sender in
            self?.googleButtonTapped(sender)
        }
        loginButtonsView.onFacebookButtonTap = { [weak self] sender in
            self?.facebookButtonTapped(sender)
        }

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
        sender?.showAnimation {
            
        }
    }
    
    private func facebookButtonTapped(_ sender: RegistrationButton?) {
        sender?.showAnimation { [weak self] in
            self?.viewOutput.userDidTapSignInWithFacebook()
        }
    }

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
        if textField == emailInput.textField {
            passwordInput.textField.becomeFirstResponder()
        } else if textField == passwordInput.textField {
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
