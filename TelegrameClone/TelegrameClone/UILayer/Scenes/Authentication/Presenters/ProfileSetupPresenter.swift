//
//  ProfileSetupPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 26.05.2024.
//

import Foundation
import FirebaseAuth

protocol ProfileSetupViewOutput: AnyObject {
    func userDidEnterDisplayName(_ displayName: String)
    func userDidEnterUsername(_ username: String)
    func userDidTapCancelButton()
    func userDidTapContinueButton(displayName: String, username: String)
}

protocol ProfileSetupViewInput: AnyObject {
    func displayUsernameHint(_ hint: String?)
    func displayDisplayNameHint(_ hint: String?)
    
    func startLoader()
    func stopLoader()
    
    func displayError(with message: String)
}

class ProfileSetupPresenter {
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: ProfileSetupViewInput?
    private let user: User
    
    enum Constants {
        static let displayNameMessage = "Display name should be between 3 and 20 characters long"
        static let userNameMessage =  "Username should be between 6 and 20 characters long"
        static let userNameMessage2 =  "Username can only contain a-z, 0-9 and underscores"
    }
    
    init(coordinator: AuthenticationCoordinator, user: User, viewInput: ProfileSetupViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
        self.user = user
    }
    
}

extension ProfileSetupPresenter: ProfileSetupViewOutput {
    func userDidEnterDisplayName(_ displayName: String) {
        if displayName.count == 0 {
            viewInput?.displayDisplayNameHint("Fill out this field")
            return
        }
        
        if displayName.count < 3 || displayName.count > 20 {
            viewInput?.displayDisplayNameHint(Constants.displayNameMessage)
        } else {
            viewInput?.displayDisplayNameHint(nil)
        }
    }
    
    func userDidEnterUsername(_ username: String) {
        if username.count == 0 {
            viewInput?.displayUsernameHint("Fill out this field")
            return
        }
        
        let regex = AppRegex.usernameRegex
        if username.count < 6 || username.count > 20 {
            viewInput?.displayUsernameHint(Constants.userNameMessage)
            return
        }
        
        let match = try? regex.firstMatch(in: username)
        if match != nil {
            viewInput?.displayUsernameHint(Constants.userNameMessage2)
        } else {
            viewInput?.displayUsernameHint(nil)
        }
    }
    
    func userDidTapCancelButton() {
        Task {
            do {
                try await AuthenticationManager.shared.deleteUser()
                await MainActor.run {
                    coordinator.goBack()
                }
            } catch {
                await MainActor.run {
                    viewInput?.displayError(with: error.localizedDescription)
                }
            }
        }
    }
    
    func userDidTapContinueButton(displayName: String, username: String) {
        viewInput?.startLoader()
        Task {
            do {
                let isUserExistes = try await UserManager.shared.isUserWithUsernameExistes(username)
                if isUserExistes {
                    await MainActor.run {
                        viewInput?.stopLoader()
                        viewInput?.displayError(with: "This username is already taken")
                    }
                    return
                }
                
                try await MainActor.run {
                    viewInput?.stopLoader()
                    let dbUser = DBUser(
                        userId: user.uid,
                        photoUrl: nil,
                        displayName: displayName,
                        username: username,
                        email: user.email ?? ""
                    )
                    
                    try UserManager.shared.createNewUser(user: dbUser)
                    coordinator.finish()
                }
            } catch {
                viewInput?.displayError(with: error.localizedDescription)
            }
        }
    }
    
    
}

