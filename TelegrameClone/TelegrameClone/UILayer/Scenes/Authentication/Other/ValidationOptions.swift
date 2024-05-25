//
//  ValidationOptions.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 12.05.2024.
//

import Foundation

struct ValidationOptions: OptionSet {
    let rawValue: UInt
    
    static let displayNameValid = ValidationOptions(rawValue: 1 << 0)
    static let usernameValid = ValidationOptions(rawValue:  1 << 1)
    static let emailValid = ValidationOptions(rawValue: 1 << 2)
    static let passwordValid = ValidationOptions(rawValue: 1 << 3)
    
    static let noneValid: ValidationOptions = []
    static let signInValid: ValidationOptions = [.emailValid, .passwordValid]
    static let signUpValid: ValidationOptions = [.displayNameValid, .usernameValid, .emailValid, .passwordValid]
}
