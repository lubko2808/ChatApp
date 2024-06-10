//
//  AuthBaseViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 08.06.2024.
//

import UIKit

class AuthBaseViewController: UIViewController {
    
    // MARK: - Views
    private let loaderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    private let loader = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupObservers()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    public func addLoader() {
        view.addSubviews(views: loaderContainer, loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        loaderContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func screenTapped() {
        view.endEditing(true)
    }
    
    func startLoader() {
        loaderContainer.isHidden = false
        loader.startAnimating()
    }
    
    func stopLoader() {
        loaderContainer.isHidden = true
        loader.stopAnimating()
    }
    
    func displayError(with message: String) {
        self.displayAlert(with: message)
    }
    
    func setupObservers() {
        startKeyboardListener()
    }
    func startKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc public func keyboardWillHide(_ notification: Notification) {}
    @objc public func keyboardWillShow(_ notification: Notification) {}
    
    func stopKeyboardListener() {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        stopKeyboardListener()
    }
    
    
}

// MARK: - UITextFieldDelegate
extension AuthBaseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.isTextFieldActive = false
    }
}
