//
//  SettingsCoordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import Foundation

final class SettingsCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showSettings()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

// MARK: - Navigation
private extension SettingsCoordinator {
    func showSettings() {
        let viewController = factory.makeSettingsScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
