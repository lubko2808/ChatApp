//
//  Onboarding Coordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import Foundation
 
final class OnboardingCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showOnboarding()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

// MARK: - Navigation
private extension OnboardingCoordinator {
    func showOnboarding() {
        let viewController = factory.makeOnboardingScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}



