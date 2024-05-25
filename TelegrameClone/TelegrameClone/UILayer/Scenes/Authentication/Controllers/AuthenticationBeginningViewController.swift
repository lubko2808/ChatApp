//
//  InitialRegistrationViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import UIKit
import SnapKit

class AuthenticationBeginningViewController: UIViewController {
    
    // MARK: - Properties
    private let viewOutput: AuthenticationBeginningViewOutput
    
    // MARK: - Views
    private let telegramLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .logoSvg)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let signInButton = CustomButton(title: "Sign In")
    private let signUpButton = CustomButton(title: "Sign Up", background: .black)
    
    // MARK: - Init
    init(viewOutput: AuthenticationBeginningViewOutput) {
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
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(views: telegramLogoView, signInButton, signUpButton)
        signInButton.addTarget(self, action: #selector(onSignInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(onSignUpButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    }
    
    private func setupConstraints() {
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(55)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(signUpButton)
            make.bottom.bottom.equalTo(signUpButton.snp.top).offset(-20)
        }
        
        telegramLogoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(170)
            make.bottom.equalTo(signInButton.snp.top).offset(-150)
        }
    }
    
}

// MARK: - Action handlers
extension AuthenticationBeginningViewController {
    
    @objc func onSignInButtonTapped() {
        viewOutput.signInButtonTapped()
    }
    
    @objc func onSignUpButtonTapped() {
        viewOutput.signUpButtonTapped()
    }
    
}


// MARK: - ViewInput
extension AuthenticationBeginningViewController: AuthenticationBeginningViewInput {
    
    
    
}
