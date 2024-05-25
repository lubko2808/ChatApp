//
//  UIViewController+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.05.2024.
//

import UIKit

extension UIViewController {
    
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
}
