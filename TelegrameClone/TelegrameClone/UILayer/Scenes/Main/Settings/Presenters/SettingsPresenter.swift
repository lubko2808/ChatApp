//
//  SettingsPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.05.2024.
//

import Foundation

protocol SettingsViewOutput: AnyObject {
    func userDidTapDeleteAccountButton()
    func userDidTapLogOutButton()
}

protocol SettingsViewInput: AnyObject {
    func displayError(with message: String)
}

class SettingsPresenter  {

    private var coordinator: SettingsCoordinator
    weak var viewInput: SettingsViewInput?
    private let authenticationManager: AuthenticationManagerProtocol
    
    init(coordinator: SettingsCoordinator, viewInput: SettingsViewInput? = nil, authenticationManager: AuthenticationManagerProtocol) {
        self.coordinator = coordinator
        self.viewInput = viewInput
        self.authenticationManager = authenticationManager
    }
    
}

// MARK: - ViewOutput
extension SettingsPresenter: SettingsViewOutput {
    func userDidTapDeleteAccountButton() {
        Task {
            do {
                try await authenticationManager.deleteUser()
                await MainActor.run {
                    coordinator.finish()
                }
            } catch {
                await MainActor.run {
                    viewInput?.displayError(with: error.localizedDescription)
                }
            }
        }
    }
    
    func userDidTapLogOutButton() {
        do {
            try authenticationManager.signOut()
            coordinator.finish()
        } catch {
            viewInput?.displayError(with: error.localizedDescription)
        }
    }
    
    
}


