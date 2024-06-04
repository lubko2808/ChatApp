//
//  SignInPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import Foundation
import FirebaseAuth

protocol SignInViewOutput: AnyObject {
    func userDidEnterEmail(_ email: String)
    func userDidEnterPassword(_ password: String)
    func userDidTapSignInButton(email: String, password: String)
    func userDidTapSignUpButton()
    func userDidTapForgotPassword()
    func userDidTapSignInWithGoogle()
    func userDidTapSignInWithFacebook()
    func userDidTapSignInWithApple()
    func userDidTapRegister()
}

protocol SignInViewInput: AnyObject {
    
    func displayEmailHint(_ hint: String?)
    func displayPasswordHint(_ hint: String?)
    
    func startLoader()
    func stopLoader()
    
    func displayError(with message: String)

}

class SignInPresenter {
    
    enum Constants {
        static let passwordMessage = "Password should be between 6 and 20 characters long"
        static let emailMessage = "This in not valid email"
    }
    
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: SignInViewInput?
    
    init(coordinator: AuthenticationCoordinator, viewInput: SignInViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
    
}

// MARK: - View Output
extension SignInPresenter: SignInViewOutput {
    func userDidTapSignUpButton() {
        coordinator.showSignUpScene()
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
    
    func userDidTapSignInButton(email: String, password: String) {
        viewInput?.startLoader()
        Task {
            do {
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                await MainActor.run {
                    viewInput?.stopLoader()
                    coordinator.finish()
                }
            } catch {
                await handleError(error)
            }
        }
    }
    
    func userDidTapForgotPassword() {
        coordinator.showForgotPasswordScene()
    }
    
    func userDidTapSignInWithGoogle() {
        viewInput?.startLoader()
        Task {
            guard let presentingVC = viewInput as? SignInViewController else { return }
            do {
                let user = try await AuthenticationManager.shared.signInWithGoogle(presenting: presentingVC)
                try await checkIfUserExists(user: user)
            } catch AuthError.idTokenIsNil {
                await MainActor.run {
                    viewInput?.stopLoader()
                    print("error: idToken is nil")
                }
            } catch {
                await handleError(error)
            }
        }
    }
    
    func userDidTapSignInWithFacebook() {
        viewInput?.startLoader()
        Task {
            guard let presentingVC = viewInput as? SignInViewController else { return }
            do {
                let user = try await AuthenticationManager.shared.signInWithFacebook(from: presentingVC)
                try await checkIfUserExists(user: user)
            } catch AuthError.FBLoginIsCancelled {
                await MainActor.run {
                    viewInput?.stopLoader()
                }
            }
            catch AuthError.FBLoginResultIsNil {
                await MainActor.run {
                    viewInput?.stopLoader()
                    print("AuthError.FBLoginResultIsNil")
                }
            } catch {
                print(error.localizedDescription)
                await handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) async {
        await MainActor.run {
            viewInput?.stopLoader()
            viewInput?.displayError(with: error.localizedDescription)
        }
    }
    
    private func checkIfUserExists(user: User) async throws {
        let isUserExists = try await UserManager.shared.isUserExists(userId: user.uid)
        await MainActor.run {
            viewInput?.stopLoader()
            if !isUserExists {
                coordinator.showProfileSetupScene(user: user)
            } else {
                coordinator.finish()
            }
        }
    }
    
    
    
    func userDidTapSignInWithApple() {
    
    }
    
    func userDidTapRegister() {
        coordinator.showSignUpScene()
    }
    
    
}
