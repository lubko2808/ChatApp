//
//  UserProfilePresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 15.06.2024.
//

import Foundation
import UIKit.UIImage

protocol UserProfileViewOutput: AnyObject {
    func viewDidLoad()
}

protocol UserProfileViewInput: AnyObject {
    func displayData(profileImage: UIImage, displayName: String, userInfo: [(String, String)])
    
    func displayError(with message: String)
}

class UserProfilePresenter {
    
    var user: DBUser
    weak var viewInput: UserProfileViewInput?
    
    init(user: DBUser) {
        self.user = user
    }
    
}

extension UserProfilePresenter: UserProfileViewOutput {
    
    func viewDidLoad() {

        Task {
            do {
                let image = try await StorageManager().getProfileImage(userId: user.userId)
                await MainActor.run {
                    var userInfo: [(String, String)] = []
                    userInfo.append(("email", user.email))
                    userInfo.append(("username", user.username))
                    viewInput?.displayData(profileImage: image, displayName: user.displayName, userInfo: userInfo)
                }
            } catch StorageManager.StorageManagerError.couldNotCreateImage {
                print("StorageManagerError.couldNotCreateImage")
            } catch {
                await MainActor.run { viewInput?.displayError(with: error.localizedDescription) }
            }
        }
        
    }
    
    
    
    
}
