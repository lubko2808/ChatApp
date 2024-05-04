//
//  ChatsCoordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import Foundation

final class ChatsCoordinator: Coordinator {
    
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
private extension ChatsCoordinator {
    func showOnboarding() {
        let viewController = factory.makeChatsScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
