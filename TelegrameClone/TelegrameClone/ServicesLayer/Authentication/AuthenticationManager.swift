//
//  AuthenticationManager.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 06.05.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

enum AuthError: Error {
    case idTokenIsNil
    case FBLoginResultIsNil
    case FBLoginIsCancelled
}
 
protocol AuthenticationManagerProtocol {
    func getAuthenticatedUser() -> User?
    func signUpUser(email: String, password: String) async -> Result<User, Error>
    func signInWithGoogle(presenting viewController: UIViewController) async throws -> User
    func signInWithFacebook(from viewController: UIViewController) async throws -> User
    func signInUser(email: String, password: String) async throws
    func resetPassword(with email: String) async throws
    func deleteUser() async throws
    func signOut() throws
}

final class AuthenticationManager: AuthenticationManagerProtocol {

    public func getAuthenticatedUser() -> User? {
        Auth.auth().currentUser
    }
    

    // MARK: - Email
    public func signUpUser(email: String, password: String) async -> Result<User, Error> {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return Result.success(authDataResult.user)
        } catch {
            return Result.failure(error)
        }
    }
    
    // MARK: - Google
    @MainActor
    public func signInWithGoogle(presenting viewController: UIViewController) async throws -> User {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        let accessToken = result.user.accessToken
        guard let idToken = result.user.idToken else {
            throw AuthError.idTokenIsNil
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return authDataResult.user
    }
    
    // MARK: - Facebook
    public func signInWithFacebook(from viewController: UIViewController) async throws -> User {
        LoginManager().logOut();
        let result = try await logInWithFacebook(from: viewController)
        print("here")
        if result.isCancelled {
            throw AuthError.FBLoginIsCancelled
        } else {
            try await startFBAuth()
            print("here 2")
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
            print("here 3")
            let result = try await Auth.auth().signIn(with: credential)
            print("here 4")
            return result.user
        }
    }
    
    private func startFBAuth() async throws {
        try await withCheckedThrowingContinuation { continuation in
            GraphRequest(graphPath: "me", parameters: [:], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get).start { _, _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        } as Void
    }
    
    @MainActor
    private func logInWithFacebook(from viewController: UIViewController) async throws -> LoginManagerLoginResult {
        try await withCheckedThrowingContinuation { continuation in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email", "public_profile"], from: viewController) { result, error in
                if let error { 
                    continuation.resume(throwing: error)
                } else if let result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: AuthError.FBLoginResultIsNil)
                }
            }
        }
    }

    public func signInUser(email: String, password: String) async throws {
        let _ = try await Auth.auth().signIn(withEmail: email, password: password)
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
