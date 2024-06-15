//
//  UIWindow+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.06.2024.
//

import Foundation

import UIKit

extension UIWindow {
  
    private class var key: UIWindow {

        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            fatalError("Fatal Error: now window is set to keyWindow")
        }
        
        return keyWindow
    }
  
    private class var keySafeAreaInsets: UIEdgeInsets {
        return UIWindow.key.safeAreaInsets
    }
    
    class var topPadding: CGFloat {
        return UIWindow.keySafeAreaInsets.top
    }
    
    class var bottomPadding: CGFloat {
        return UIWindow.keySafeAreaInsets.bottom
    }
    
}
