//
//  PageCell.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.06.2024.
//

import UIKit
import Lottie
import SnapKit

class PageCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let cellId = "PageCell"
    
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.Roboto.bold.size(of: 30)
        return label
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.Roboto.regular.size(of: 20)
        return label
    }()
    private let lottieView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(lottieView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        lottieView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
    }

    public func setupCell(item: PageItem) {
        lottieView.animation = LottieAnimation.named(item.animationName)
        titleLabel.text = item.title
        textLabel.text = item.text
        contentView.backgroundColor = item.backgroundColor
    }
    
    public func stopAnimation() {
        lottieView.stop()
    }
    
    public func playAnimation() {
        lottieView.play()
    }
    
}
