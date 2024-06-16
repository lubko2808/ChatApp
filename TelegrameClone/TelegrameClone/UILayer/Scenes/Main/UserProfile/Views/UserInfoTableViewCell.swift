//
//  UserInfoTableViewCell.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 16.06.2024.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    static let cellId = "UserInfoTableViewCell"
    
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regular.size(of: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto.regular.size(of: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Cell Configure
    public func configureCell(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
    
   // MARK: - Separator
    var hidesBottomSeparator = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSeparator = subviews.first { $0.frame.minY >= bounds.maxY - 1 && $0.frame.height <= 1 }
        bottomSeparator?.isHidden = hidesBottomSeparator
    }
    
}
