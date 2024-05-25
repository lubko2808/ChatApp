//
//  AuthenticationManager.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 06.05.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
    
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    public func getAuthenticatedUser() -> User? {
        Auth.auth().currentUser
    }
    
//    @discardableResult
//    public func createUser(email: String, password: String) async throws -> User {
//        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        return authDataResult.user
//    }
    
    public func signUpUser(email: String, password: String) async -> Result<User, Error> {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return Result.success(authDataResult.user)
        } catch {
            return Result.failure(error)
        }
    }
    
    
    
    @discardableResult
    public func signInUser(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authDataResult.user
    }
    
    public func resetPassword(with email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public func deleteUser() async throws {
        let currentUser = getAuthenticatedUser()
        try await currentUser?.delete()
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
