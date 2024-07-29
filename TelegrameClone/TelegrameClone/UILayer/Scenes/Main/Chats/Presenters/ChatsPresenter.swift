//
//  ChatsPresenter.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 28.07.2024.
//

import Foundation
import Combine

protocol ChatsViewOutput: AnyObject {
    func userNeedsMoreUsers(prefix: String)
}

protocol ChatsViewInput: AnyObject {
    var searchText: PassthroughSubject<String, Never> { get }
    func updateUsers(_ users: [DBUser])
    func addUsers(_ users: [DBUser])
    func showContentUnavailableIcon()
    func hideContentUnavailableIcon()
}

class ChatsPresenter {
    weak var viewInput: ChatsViewInput?
    private let coordinator: ChatsCoordinator
    private let userManager: UserManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private enum Constants {
        static let queryLimit = 15
    }
    
    init(coordinator: ChatsCoordinator ,userManager: UserManagerProtocol) {
        self.coordinator = coordinator
        self.userManager = userManager
    }
    
    var isThereToDataLoad = true
    var isPaginating = false
    
    public func setViewInput(viewInput: ChatsViewInput) {
        self.viewInput = viewInput
        self.viewInput?.searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.userManager.resetUserSearch()
                if text.isEmpty {
                    viewInput.updateUsers([])
                    viewInput.hideContentUnavailableIcon()
                    return
                }
                self?.fetchUsers(prefix: text)
            })
            .store(in: &cancellables)
    }
    
    func fetchUsers(prefix: String) {
        Task { @MainActor in
            do {
                let users = try await userManager
                    .getUsers(with: prefix, limit: Constants.queryLimit)
                
                isThereToDataLoad = users.count == Constants.queryLimit ? true : false
                
                if users.isEmpty && !isPaginating {
                    viewInput?.showContentUnavailableIcon()
                } else {
                    viewInput?.hideContentUnavailableIcon()
                }
                
                if isPaginating {
                    viewInput?.addUsers(users)
                    isPaginating = false
                } else {
                    viewInput?.updateUsers(users)
                }

            } catch let error as StorageManager.StorageManagerError {
                print(error.localizedDescription)
            } catch {}
        }
    }
    
}

extension ChatsPresenter: ChatsViewOutput {
    func userNeedsMoreUsers(prefix: String) {
        if isThereToDataLoad && !isPaginating {
            isPaginating = true
            fetchUsers(prefix: prefix)
        }
    }
}
