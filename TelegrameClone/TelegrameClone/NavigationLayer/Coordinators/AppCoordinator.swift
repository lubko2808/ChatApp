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
        if UserStorage.shared.passedOnboarding {
            let authUser = AuthenticationManager().getAuthenticatedUser()
            
            if authUser == nil {
                showRegisterFlow()
            } else {
                showMainFlow()
            }
        } else {
            showOnboardingFlow()
        }

    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
    
}

// MARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navigationController: navigationController, finishDelegate: self)
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainFlow() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        let tabBarController = factory.makeMainScene(coordinator: self)
        navigationController.pushViewController(tabBarController, animated: true)
    }

    func showRegisterFlow() {
        guard let navigationController = navigationController else { return }
        let registrationCoordinator = AuthenticationCoordinator(type: .registration, navigationController: navigationController, finishDelegate: self)
        addChildCoordinator(registrationCoordinator)
        registrationCoordinator.start()
    }
    
}

// MARK: - CoordinatorFinishDelegate
extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)

        switch childCoordinator.type {
        case .registration:
            showMainFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .settings:
            showRegisterFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .onboarding:
            showRegisterFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        default:
            break
//            navigationController?.popToRootViewController(animated: false)
        }
    }
    
}



