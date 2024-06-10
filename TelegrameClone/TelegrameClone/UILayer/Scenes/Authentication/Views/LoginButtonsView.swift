//
//  LoginButtons.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 03.06.2024.
//

import UIKit
import RxSwift
import RxRelay

class LoginButtonsView: UIView {
    
    // MARK: - Properties
    private let googleButtonRelay = PublishRelay<RegistrationButton?>()
    public var googleButtonTapped: Observable<RegistrationButton?> {
        googleButtonRelay.asObservable()
    }
    private let appleButtonRelay = PublishRelay<RegistrationButton?>()
    public var appleButtonTapped: Observable<RegistrationButton?> {
        appleButtonRelay.asObservable()
    }
    private let facebookButtonRelay = PublishRelay<RegistrationButton?>()
    public var facebookButtonTapped: Observable<RegistrationButton?> {
        facebookButtonRelay.asObservable()
    }
    
    // MARK: - Views
    private let dividerView = DividerView(title: "")
    
    private let googleButton = RegistrationButton(type: .google)
    private let appleButton = RegistrationButton(type: .apple)
    private let facebookButton = RegistrationButton(type: .facebook)

    
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        dividerView.title = title
        translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(views: dividerView, googleButton, appleButton, facebookButton)
        googleButton.addAction(UIAction { [weak self] action in
            self?.googleButtonRelay.accept( action.sender as? RegistrationButton )
        }, for: .touchUpInside)
        
        appleButton.addAction(UIAction { [weak self] action in
            self?.appleButtonRelay.accept( action.sender as? RegistrationButton )
        }, for: .touchUpInside)
        
        facebookButton.addAction(UIAction { [weak self] action in
            self?.facebookButtonRelay.accept( action.sender as? RegistrationButton )
        }, for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        dividerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(28)
        }
        
        let availableSpace = -(2 * 8)
        facebookButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(dividerView.snp.bottom).offset(22)
            make.width.equalToSuperview().offset( availableSpace / 3 ).dividedBy(3)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        googleButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(dividerView.snp.bottom).offset(22)
            make.width.equalToSuperview().offset( availableSpace / 3).dividedBy(3)
            make.leading.equalTo(facebookButton.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
        }
        
        appleButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(dividerView.snp.bottom).offset(22)
            make.width.equalToSuperview().offset( availableSpace / 3 ).dividedBy(3)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
