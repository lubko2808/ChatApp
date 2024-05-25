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

}

protocol ForgotPasswordViewInput: AnyObject {
    
    func displayEmailHint(_ hint: String?)
    func displayPopUp(with message: String)
    func displayError(with message: String)
}

class ForgotPasswordPresenter {
    
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: ForgotPasswordViewInput?
    
    init(coordinator: AuthenticationCoordinator, viewInput: ForgotPasswordViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
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
        Task {
            do {
                try await AuthenticationManager.shared.resetPassword(with: email)
                await MainActor.run {
                    viewInput?.displayPopUp(with: "We have sent you email")
                }
            } catch {
                await MainActor.run {
                    viewInput?.displayError(with: error.localizedDescription)
                }
            }
        }
        
    }
    
}
