//
//  IntiailRegistrationPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.05.2024.
//

import Foundation

protocol AuthenticationBeginningViewOutput: AnyObject {
    
    func signInButtonTapped()
    func signUpButtonTapped()
    
}

protocol AuthenticationBeginningViewInput: AnyObject {
    
}

class AuthenticationBeginningPresenter: AuthenticationBeginningViewOutput {
    
    private var coordinator: AuthenticationCoordinator
    weak var viewInput: AuthenticationBeginningViewInput?
    
    init(coordinator: AuthenticationCoordinator, viewInput: AuthenticationBeginningViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
    
    func signInButtonTapped() {
        coordinator.showSignInScene()
    }
    
    func signUpButtonTapped() {
        coordinator.showSignUpScene()
    }
    
    
    
    
}
