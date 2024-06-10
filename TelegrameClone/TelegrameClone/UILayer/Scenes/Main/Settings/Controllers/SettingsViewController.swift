//
//  SettingsViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewOutput: SettingsViewOutput
    
    // MARK: - Views
    let logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("log out", for: .normal)
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("delete account", for: .normal)
        return button
    }()
    
    // MARK: - Init
    init(viewOutput: SettingsViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(logOutButton)
        view.addSubview(deleteAccountButton)
        
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        logOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(100)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logOutButton.snp.bottom).inset(100)
        }
    }

    @objc private func logOutButtonTapped() {
        viewOutput.userDidTapLogOutButton()
    }
    
    @objc private func deleteAccountButtonTapped() {
        viewOutput.userDidTapDeleteAccountButton()
    }
    
}

// MARK: - ViewInput
extension SettingsViewController: SettingsViewInput {
    
    func displayError(with message: String) {
        self.displayAlert(with: message)
        
        
    }
    
    
}
