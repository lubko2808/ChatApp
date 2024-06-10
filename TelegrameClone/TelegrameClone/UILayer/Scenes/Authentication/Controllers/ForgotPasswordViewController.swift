//
//  ForgotPasswordViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 12.05.2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    private var viewOutput: ForgotPasswordViewOutput
    private var isEmailValid = false
    
    // MARK: - Views
    private let popUpView = PopUpView(frame: .zero)
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Forgot Password?"
        label.font = UIFont.Roboto.bold.size(of: 40)
        label.numberOfLines = 0
        return label
    }()

    private lazy var emailInput = TextFieldWithWint(type: .email, delegate: self, returnKeyType: .done)
    
    private let sendButton = CustomButton(title: "Send")
    
    private lazy var rememberPasswordLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString.textWithHiglightes(text: "Remember Password? Login", highlightedText: "Login")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addRangeGesture(stringRange: "Login") { [weak self] in
            self?.viewOutput.userDidTapLogin()
        }
        return label
    }()
    
    // MARK: - Init
    
    init(viewOutput: ForgotPasswordViewOutput) {
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
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - setup
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(views: forgotPasswordLabel, emailInput, sendButton, rememberPasswordLabel)
        
        sendButton.isActive = false
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(65)
            make.centerX.equalToSuperview()
        }

        emailInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(50)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailInput.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        
        rememberPasswordLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
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
    
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = textField.text else { return }
        viewOutput.userDidEnterEmail(email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
    
}

// MARK: - Action Handlers
extension ForgotPasswordViewController {
    
    @objc private func sendButtonTapped() {
        guard let email = emailInput.textField.text else { return }
        viewOutput.userDidTapSendButton(email: email)
    }
    
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
}

// MARK: - ViewInput
extension ForgotPasswordViewController: ForgotPasswordViewInput {
    func displayEmailHint(_ hint: String?) {
        if hint == nil {
            sendButton.isActive = true
        } else {
            sendButton.isActive = false
        }

        guard let hint else {
            emailInput.hintLabel.text = ""
            return
        }
        emailInput.hintLabel.text = hint
        emailInput.hintLabel.textColor = .red
    }
    
    func displayPopUp(with message: String) {
        popUpView.show(with: message, on: self.view)
    }
    
    func displayError(with message: String) {
        self.displayAlert(with: message)
    }
    
    
}
