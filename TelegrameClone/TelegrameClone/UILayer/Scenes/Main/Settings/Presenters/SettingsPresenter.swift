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
    
    init(coordinator: SettingsCoordinator, viewInput: SettingsViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
    
}

// MARK: - ViewOutput
extension SettingsPresenter: SettingsViewOutput {
    func userDidTapDeleteAccountButton() {
        Task {
            do {
                try await AuthenticationManager.shared.deleteUser()
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
            try AuthenticationManager.shared.signOut()
            coordinator.finish()
        } catch {
            viewInput?.displayError(with: error.localizedDescription)
        }
    }
    
    
}


