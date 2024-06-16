//
//  UserProfileCustomButtonView.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 16.06.2024.
//

import UIKit

class UserProfileCustomButtonView: UIView {
    
    // MARK: - Properties
    private var aspectRatio: CGFloat?
    
    enum UserProfileButtonType {
        case message
        case call
        case mute
        case more
    }
    
    // MARK: - Views
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .blue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .blue
        return label
    }()
    
    // MARK: - Init
    init(type: UserProfileButtonType) {
        super.init(frame: .zero)
        setupViews(type: type)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews(type: UserProfileButtonType) {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        var icon: UIImage?
        switch type {
        case .message:
            icon = UIImage(systemName: "message.fill")
            iconImageView.image = icon
            titleLabel.text = "Message"
        case .call:
            icon = UIImage(named: "Vector")?.withRenderingMode(.alwaysTemplate)
            iconImageView.image = icon
            titleLabel.text = "Call"
        case .mute:
            icon = UIImage(systemName: "bell.slash.fill")
            iconImageView.image = icon
            titleLabel.text = "Mute"
        case .more:
            icon = UIImage(systemName: "ellipsis")
            iconImageView.image = icon
            titleLabel.text = "More"
        }
        if let width = icon?.size.width, let height = icon?.size.height {
            aspectRatio = width / height
        }
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            
            let height: CGFloat = 27
            make.height.equalTo(height)
            make.width.equalTo(height * (aspectRatio ?? 0))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }

}
