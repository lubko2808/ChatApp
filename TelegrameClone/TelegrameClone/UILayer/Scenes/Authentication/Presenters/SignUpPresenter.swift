//
//  SignUpPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import Foundation

protocol SignUpViewOutput: AnyObject {
    func userDidEnterDisplayName(_ displayName: String)
    func userDidEnterUsername(_ username: String)
    func userDidEnterEmail(_ email: String)
    func userDidEnterPassword(_ password: String)
    func userDidTapSignUpButton(displayName: String, username: String, email: String, password: String)
}

protocol SignUpViewInput: AnyObject {
    
    func displayDisplayNameHint(_ hint: String?)
    func displayUsernameHint(_ hint: String?)
    func displayEmailHint(_ hint: String?)
    func displayPasswordHint(_ hint: String?)
    
    func startLoader()
    func stopLoader()
    
    func displayError(with message: String)
    
}

class SignUpPresenter {
    
    enum Constants {
        static let displayNameMessage = "Display name should be between 3 and 20 characters long"
        static let userNameMessage =  "Username should be between 6 and 20 characters long"
        static let userNameMessage2 =  "Username can only contain a-z, 0-9 and underscores"
        static let passwordMessage = "Password should be between 6 and 20 characters long"
        static let emailMessage = "This in not valid email"
    }
    
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: SignUpViewInput?
    
    init(coordinator: AuthenticationCoordinator, viewInput: SignUpViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
    
}

// MARK: - View Output
extension SignUpPresenter: SignUpViewOutput {
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
    
    func userDidEnterEmail(_ email: String) {
        if email.count == 0 {
            viewInput?.displayEmailHint("Fill out this field")
            return
        }

        let regex = AppRegex.emailRegex
        let match = try? regex.wholeMatch(in: email)
        if match == nil {
            viewInput?.displayEmailHint(Constants.emailMessage)
        } else {
            viewInput?.displayEmailHint(nil)
        }
    }
    
    func userDidEnterPassword(_ password: String) {
        if password.count == 0 {
            viewInput?.displayPasswordHint("Fill out this field")
            return
        }
        
        if password.count < 6 || password.count > 20 {
            viewInput?.displayPasswordHint(Constants.passwordMessage)
        } else {
            viewInput?.displayPasswordHint(nil)
        }
    }
    
    func userDidTapSignUpButton(displayName: String, username: String, email: String, password: String) {
        viewInput?.startLoader()
        Task {
            let result = await AuthenticationManager.shared.signUpUser(email: email, password: password)
            await MainActor.run {
                viewInput?.stopLoader()
                switch result {
                case .success(let user):
                    let user = DBUser(userId: user.uid, 
                                      photoUrl: nil,
                                      displayName: displayName,
                                      username: username,
                                      email: user.email ?? "")
                    do {
                        try UserManager.shared.createNewUser(user: user)
                    } catch {
                        print(#file, #function, error.localizedDescription)
                    }
                    coordinator.finish()
                case .failure(let error):
                    viewInput?.displayError(with: error.localizedDescription)
                }
            }
        }
    }
    
    func signUp(with email: String, password: String) async throws {
        
//        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        
    }
    
}


