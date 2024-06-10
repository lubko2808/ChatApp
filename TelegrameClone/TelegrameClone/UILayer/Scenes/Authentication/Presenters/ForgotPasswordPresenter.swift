//
//  ForgotPasswordPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 12.05.2024.
//

import Foundation

protocol ForgotPasswordViewOutput: AnyObject {
    func userDidEnterEmail(_ email: String)
    func userDidTapSendButton(email: String)
    func userDidTapLogin()
}

protocol ForgotPasswordViewInput: AnyObject {
    func displayEmailHint(_ hint: String?)
    func displayPopUp(with message: String)
    func displayError(with message: String)
}

class ForgotPasswordPresenter {
    
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: ForgotPasswordViewInput?
    private let authenticationManager: AuthenticationManagerProtocol
    
    init(coordinator: AuthenticationCoordinator, 
         viewInput: ForgotPasswordViewInput? = nil,
         authenticationManager: AuthenticationManagerProtocol) {
        self.coordinator = coordinator
        self.viewInput = viewInput
        self.authenticationManager = authenticationManager
    }
    
}

// MARK: - View Output
extension ForgotPasswordPresenter: ForgotPasswordViewOutput {
    func userDidEnterEmail(_ email: String) {
        if email.count == 0 {
            viewInput?.displayEmailHint("Fill out this field")
            return
        }

        let regex = AppRegex.emailRegex
        let match = try? regex.wholeMatch(in: email)
        if match == nil {
            viewInput?.displayEmailHint("This is not valid email")
        } else {
            viewInput?.displayEmailHint(nil)
        }
    }
    
    func userDidTapSendButton(email: String) {
        Task { @MainActor in
            do {
                try await authenticationManager.resetPassword(with: email)
                viewInput?.displayPopUp(with: "We have sent you email")
            } catch {
                viewInput?.displayError(with: error.localizedDescription)
            }
        }
        
    }
    
    func userDidTapLogin() {
        coordinator.showSignInScene()
    }
    
}
