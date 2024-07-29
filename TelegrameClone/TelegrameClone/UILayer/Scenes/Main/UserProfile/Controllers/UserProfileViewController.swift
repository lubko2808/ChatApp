//
//  UserProfileViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 15.06.2024.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var userInfo: [(String, String)] = []
    private let viewOutput: UserProfileViewOutput
    
    // MARK: - Views
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Roboto.regular.size(of: 27)
        return label
    }()
    
    private let messageButton = UserProfileCustomButtonView(type: .message)
    private let callButton = UserProfileCustomButtonView(type: .call)
    private let muteButton = UserProfileCustomButtonView(type: .mute)
    private let moreButton = UserProfileCustomButtonView(type: .more)
    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy private var userInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    init(viewOutput: UserProfileViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewOutput.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .systemGray6
        view.addSubviews(views: profileImageView, displayNameLabel, hStack, userInfoTableView)
        hStack.addArrangedSubview(messageButton)
        hStack.addArrangedSubview(callButton)
        hStack.addArrangedSubview(muteButton)
        hStack.addArrangedSubview(moreButton)
        
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.size.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        displayNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        hStack.snp.makeConstraints { make in
            make.top.equalTo(displayNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        userInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(hStack.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        
    }
}

// MARK: - UserProfileViewInput
extension UserProfileViewController: UserProfileViewInput {
    
    func displayData(profileImage: UIImage, displayName: String, userInfo: [(String, String)]) {
        profileImageView.image = profileImage
        displayNameLabel.text = displayName
        self.userInfo = userInfo
        self.userInfoTableView.reloadData()
    }

    func displayError(with message: String) {
        self.displayAlert(with: message)
    }
    
}

// MARK: - UITableViewDelegate
extension UserProfileViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

}

// MARK: - UITableViewDataSource
extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.cellId, for: indexPath) as? UserInfoTableViewCell else {
            return UITableViewCell()
        }
        let title = userInfo[indexPath.row].0
        let body = userInfo[indexPath.row].1
        cell.configureCell(title: title, body: body)
        
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        cell.hidesBottomSeparator = indexPath.row == numberOfRows - 1
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if indexPath.row == 1 {
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        return cell
    }
    
}



