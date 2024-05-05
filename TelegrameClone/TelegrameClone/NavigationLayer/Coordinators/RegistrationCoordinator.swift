//
//  RegistrationCoordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import Foundation

final class RegistrationCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showSignInScene()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

// MARK: - Navigation
private extension RegistrationCoordinator {
    func showSignInScene() {
        let viewController = factory.makeSignInScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
