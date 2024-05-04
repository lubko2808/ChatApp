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
        
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

