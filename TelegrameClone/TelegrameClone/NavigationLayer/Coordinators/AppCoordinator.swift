//
//  AppCoordinator.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let userStorage = UserStorage.shared
    private let factory = SceneFactory.self
    private let window: UIWindow?
    
    
    init(childCoordinators: [CoordinatorProtocol] = [CoordinatorProtocol](), type: CoordinatorType, navigationController: UINavigationController, finishDelegate: CoordinatorFinishDelegate? = nil, window: UIWindow) {
        self.window = window
        super.init(childCoordinators: childCoordinators, type: type, navigationController: navigationController, finishDelegate: finishDelegate)
    }
    
    override func start() {
        showRegisterFlow()
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
    
}

// MARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navigationController: navigationController)
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainFlow() {
//        guard let navigationController = navigationController else { return }
        let tabBarController = factory.makeMainScene(coordinator: self)
        self.window?.rootViewController = tabBarController
    }

    func showRegisterFlow() {
        guard let navigationController = navigationController else { return }
        let registrationCoordinator = RegistrationCoordinator(type: .registration, navigationController: navigationController)
        addChildCoordinator(registrationCoordinator)
        registrationCoordinator.start()
    }
    
    
}

// MARK: - CoordinatorFinishDelegate
extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
//        switch childCoordinator.type {
//        case .onboarding:
//            
//        case .registration:
//            
//        case .contacts:
//            
//        case .chats:
//            
//        case .settings:
//            break
//        default:
//            navigationController?.popToRootViewController(animated: false)
//        }
    }
    
}



