//
//  OnboardingPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 14.06.2024.
//

import Foundation

protocol OnboardingViewOutput: AnyObject {
    func userDidFinishOnboarding()
}

class OnboardingPresenter {
    
    private var coordinator: OnboardingCoordinator
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
}

// MARK: - View Output
extension OnboardingPresenter: OnboardingViewOutput {
    
    func userDidFinishOnboarding() {
        UserStorage.shared.passedOnboarding = true
        coordinator.finish()
    }

}



