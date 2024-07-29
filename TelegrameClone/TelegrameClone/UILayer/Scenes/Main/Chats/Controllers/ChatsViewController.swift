//
//  ChatsViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import UIKit
import Combine

let sampleData = [
    DBUser(userId: "", photoUrl: URL(string: "https://www.youtube.com/watch?v=-joSiASAnjA")!, displayName: "John", username: "john123", email: ""),
    DBUser(userId: "", photoUrl: URL(string: "https://www.youtube.com/watch?v=-joSiASAnjA")!, displayName: "Ann", username: "fnnjndecv", email: ""),
    DBUser(userId: "", photoUrl: URL(string: "https://www.youtube.com/watch?v=-joSiASAnjA")!, displayName: "Qasddf", username: "frfvfvb", email: ""),
]

class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    private var users: [DBUser] = []
    let searchText = PassthroughSubject<String, Never>()
    private let viewOutput: ChatsViewOutput

    // MARK: - Views
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
//        tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatPreviewTableViewCell.self, forCellReuseIdentifier: ChatPreviewTableViewCell.Id)
        return tableView
    }()
    
    private let searchController = UISearchController()
    
    private let contentUnavailabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .unavailable)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - Init
    init(viewOutput: ChatsViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        title = "Chats"
        view.addSubview(tableView)
        view.addSubview(contentUnavailabelImageView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentUnavailabelImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(250)
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ChatPreviewTableViewCell else {
            return
        }
        cell.cancelDownload()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ChatPreviewTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            viewOutput.userNeedsMoreUsers(prefix: searchController.text)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatPreviewTableViewCell.Id, for: indexPath) as? ChatPreviewTableViewCell else {
            return UITableViewCell()
        }
        
        let userId = users[indexPath.row].userId
        let displayName = users[indexPath.row].displayName
        let username = users[indexPath.row].username
        cell.configureCell(userId: userId, displayName: displayName, username: username)
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension ChatsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {   
        searchText.send(searchController.text)
    }
    
}


// MARK: - ChatsViewInput
extension ChatsViewController: ChatsViewInput {
    func updateUsers(_ users: [DBUser]) {
        self.users = users
        self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
    }
    
    func addUsers(_ users: [DBUser]) {
        let indexes = users.indices.map { index in
            IndexPath(row: self.users.count + index, section: 0)
        }
        self.users.append(contentsOf: users)
        tableView.insertRows(at: indexes, with: .left)
    }
    
    func showContentUnavailableIcon() {
        UIView.animate(withDuration: 0.2) {
            self.contentUnavailabelImageView.alpha = 1
        }
    }
    
    func hideContentUnavailableIcon() {
        UIView.animate(withDuration: 0.2) {
            self.contentUnavailabelImageView.alpha = 0
        }
    }
    
}
