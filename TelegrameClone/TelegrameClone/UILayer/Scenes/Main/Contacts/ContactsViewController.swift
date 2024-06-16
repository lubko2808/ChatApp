//
//  ContactsViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import UIKit

class ContactsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        Task {
            let user = try await UserManager().getUser(userId: AuthenticationManager().getAuthenticatedUser()!.uid)
            await MainActor.run {
                let presenter = UserProfilePresenter(user: user)
                let controller = UserProfileViewController(viewOutput: presenter)
                presenter.viewInput = controller
                self.navigationController?.pushViewController(controller, animated: false)
                
            }
        }
        
    }
    
}
