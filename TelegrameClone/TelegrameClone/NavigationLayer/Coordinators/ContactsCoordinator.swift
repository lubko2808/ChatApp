//
//  ContactsCoordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import Foundation

final class ContactsCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showContactsScene()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

// MARK: - Navigation
private extension ContactsCoordinator {
    func showContactsScene() {
        let viewController = factory.makeContactsScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
