//
//  PopUpView.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 12.05.2024.
//

import Foundation

import UIKit
import Combine

class PopUpView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.Roboto.regular.size(of: 40)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var message: String? {
        didSet {
            guard let message = message else { return }
            messageLabel.text = message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
        }
        
        self.clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopUpView {
    
    public func show(with message: String, on view: UIView) {
        view.addSubview(self)
        self.message = message
        
        self.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(-60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
        self.layoutIfNeeded()
        self.snp.makeConstraints { make in
            make.height.equalTo(messageLabel.intrinsicContentSize.height + 20)
        }
        
        let distance = (view.frame.height) / 2.0
        transform = CGAffineTransform(translationX: 0, y: distance)
        alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
        
        Timer.publish(every: 1.3, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { _ in
                UIView.animate(withDuration: 0.5) {
                    self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.alpha = 0
                } completion: { _ in
                    self.removeFromSuperview()
                }
            }
            .store(in: &subscriptions)
    }
    
}
