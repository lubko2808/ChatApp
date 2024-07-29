//
//  UISearchController+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 28.07.2024.
//

import UIKit

extension UISearchController {
    var text: String {
        self.searchBar.text ?? ""
    }
}


