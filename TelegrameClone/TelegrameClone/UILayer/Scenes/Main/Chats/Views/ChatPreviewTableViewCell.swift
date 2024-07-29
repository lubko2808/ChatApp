//
//  ChatPreviewTableViewCell.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 28.07.2024.
//

import UIKit

class ChatPreviewTableViewCell: UITableViewCell {
    
    static let Id = "ChatPreviewTableViewCell"
    static let cellHeight: CGFloat = 80
    private let storageManager: ProfileImageFetcher = StorageManager()
    
    private enum UIConstants {
        static let profileImageSize: CGFloat = 60
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = UIConstants.profileImageSize / 2
        imageView.layer.masksToBounds = false
        imageView.backgroundColor = .systemGray5
        imageView.layer.shadowRadius = 1
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowColor = UIColor.black.cgColor
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Roboto.medium.size(of: 18)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Roboto.regular.size(of: 18)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(usernameLabel)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.height.width.equalTo(UIConstants.profileImageSize)
        }
        
        displayNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLabel)
            make.top.equalTo(displayNameLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    public func cancelDownload() {
        task?.cancel()
    }
    
    private var task: Task<Void, any Error>? = nil
    
    public func configureCell(userId: String, displayName: String, username: String) {
        displayNameLabel.text = displayName
        usernameLabel.text = "@" + username
        task = Task { @MainActor in
            let image = try await storageManager.getProfileImage(userId: userId)
            profileImageView.image = image
        }
    }
}
