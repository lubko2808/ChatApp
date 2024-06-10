//
//  DividerView.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 25.05.2024.
//

import UIKit

class DividerView: UIView {
    
    private let leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Roboto.medium.size(of: 14)
        label.textColor = UIColor.gray
        return label
    }()
    private let rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    init(title: String = "") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        addSubviews(views: leftLine, titleLabel, rightLine)
        setConstraints()
    }
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        leftLine.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(2)
            make.right.equalTo(titleLabel.snp.left).offset(-8)
        }
        
        rightLine.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(2)
            make.left.equalTo(titleLabel.snp.right).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
