//
//  SignUpPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

protocol SignUpViewOutput: AnyObject {
    func userDidEnterDisplayName(_ displayName: String)
    func userDidEnterUsername(_ username: String)
    func userDidEnterEmail(_ email: String)
    func userDidEnterPassword(_ password: String)
    func userDidTapSignUpButton(displayName: String, username: String, email: String, password: String)
    func userDidTapSignUpWithApple()
    func userDidTapSignUpWithGoogle()
    func userDidTapSignUpWithFacebook()
    func userDidTapLogin()
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
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    private let imageRenderer: ImageRendererProtocol
    private let storageManager: StorageManagerProtocol
    
    init(coordinator: AuthenticationCoordinator, 
         viewInput: SignUpViewInput? = nil,
         authenticationManager: AuthenticationManagerProtocol,
         userManager: UserManagerProtocol,
         imageRenderer: ImageRendererProtocol,
         storageManager: StorageManagerProtocol) {
        self.coordinator = coordinator
        self.viewInput = viewInput
        self.authenticationManager = authenticationManager
        self.userManager = userManager
        self.imageRenderer = imageRenderer
        self.storageManager = storageManager
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
        Task { @MainActor in
            viewInput?.startLoader()
            let isUserExistes = try await userManager.isUserWithUsernameExistes(username)
            if isUserExistes {
                await handleError("This username is already taken")
                return
            }
     
            let result = await authenticationManager.signUpUser(email: email, password: password)
            switch result {
            case .success(let user):
                let profileImage = imageRenderer.createDefaultProfilePicture(titleLetter: displayName.first ?? Character(""))
                let profileImageUrl = try await storageManager.uploadProfileImage(profileImage, userId: user.uid)
                let user = DBUser(userId: user.uid,
                                  photoUrl: profileImageUrl,
                                  displayName: displayName,
                                  username: username,
                                  email: user.email ?? "")
                do {
                    try userManager.createNewUser(user: user)
                } catch {
                    print(#file, #function, error.localizedDescription)
                }
                viewInput?.stopLoader()
                coordinator.finish()
            case .failure(let error):
                viewInput?.displayError(with: error.localizedDescription)
            }
        }
    }
    
    func userDidTapSignUpWithApple() {
        
    }
    
    func userDidTapSignUpWithGoogle() {
        Task { @MainActor in
            viewInput?.startLoader()
            guard let presentingVC = viewInput as? SignUpViewController else { return }
            do {
                let user = try await authenticationManager.signInWithGoogle(presenting: presentingVC)
                try await checkIfUserExists(user: user)
            } catch AuthError.idTokenIsNil {
                viewInput?.stopLoader()
                print("error: idToken is nil")
            } catch GIDSignInError.canceled {
                viewInput?.stopLoader()
            }
            catch {
                await handleError(error.localizedDescription)
            }
        }
    }
    
    func userDidTapSignUpWithFacebook() {
        Task { @MainActor in
            viewInput?.startLoader()
            guard let presentingVC = viewInput as? SignUpViewController else { return }
            do {
                let user = try await authenticationManager.signInWithFacebook(from: presentingVC)
                try await checkIfUserExists(user: user)
            } catch AuthError.FBLoginIsCancelled {
                viewInput?.stopLoader()
            } catch AuthError.FBLoginResultIsNil {
                viewInput?.stopLoader()
                print("AuthError.FBLoginResultIsNil")
            } catch {
                print(error.localizedDescription)
                await handleError(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func handleError(_ errorDescription: String) async {
        viewInput?.stopLoader()
        viewInput?.displayError(with: errorDescription)
    }
    
    @MainActor
    private func checkIfUserExists(user: User) async throws {
        let isUserExists = try await userManager.isUserExists(userId: user.uid)
        viewInput?.stopLoader()
        if !isUserExists {
            coordinator.showProfileSetupScene(user: user)
        } else {
            coordinator.finish()
        }
    }
    
    func userDidTapLogin() {
        coordinator.showSignInScene()
    }

    
}


