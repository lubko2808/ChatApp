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
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    private let imageRenderer: ImageRendererProtocol
    private let storageManager: StorageManagerProtocol
    private let user: User
    
    enum Constants {
        static let displayNameMessage = "Display name should be between 3 and 20 characters long"
        static let userNameMessage =  "Username should be between 6 and 20 characters long"
        static let userNameMessage2 =  "Username can only contain a-z, 0-9 and underscores"
    }
    
    init(coordinator: AuthenticationCoordinator, viewInput: ProfileSetupViewInput? = nil, authenticationManager: AuthenticationManagerProtocol, userManager: UserManagerProtocol, imageRenderer: ImageRendererProtocol, storageManager: StorageManagerProtocol, user: User) {
        self.coordinator = coordinator
        self.viewInput = viewInput
        self.authenticationManager = authenticationManager
        self.userManager = userManager
        self.imageRenderer = imageRenderer
        self.storageManager = storageManager
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
        
        if username.count < 6 || username.count > 20 {
            viewInput?.displayUsernameHint(Constants.userNameMessage)
            return
        }
        
        let regex = AppRegex.usernameRegex
        let match = try? regex.firstMatch(in: username)
        if match != nil {
            viewInput?.displayUsernameHint(Constants.userNameMessage2)
        } else {
            viewInput?.displayUsernameHint(nil)
        }
    }
    
    
    func userDidTapCancelButton() {
        Task { @MainActor in
            do {
                try await authenticationManager.deleteUser()
                coordinator.goBack()
            } catch {
                viewInput?.displayError(with: error.localizedDescription)
            }
        }
    }
    
    func userDidTapContinueButton(displayName: String, username: String) {
        Task { @MainActor in
        viewInput?.startLoader()
            do {
                let isUserExistes = try await userManager.isUserWithUsernameExistes(username)
                if isUserExistes {
                    viewInput?.stopLoader()
                    viewInput?.displayError(with: "This username is already taken")
                    return
                }
                
                let profileImage = imageRenderer.createDefaultProfilePicture(titleLetter: displayName.first ?? Character(""))
                let profileImageUrl = try await storageManager.uploadProfileImage(profileImage, userId: user.uid)
                
                let dbUser = DBUser(
                    userId: user.uid,
                    photoUrl: profileImageUrl,
                    displayName: displayName,
                    username: username,
                    email: user.email ?? ""
                )
                
                try userManager.createNewUser(user: dbUser)
                viewInput?.stopLoader()
                coordinator.finish()
                
            } catch {
                viewInput?.displayError(with: error.localizedDescription)
            }
        }
    }
    
}
