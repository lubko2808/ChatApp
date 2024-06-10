//
//  UserManager.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 11.05.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let photoUrl: URL
    let displayName: String
    let username: String
    let email: String
    let dateCreated: Date
    
    init(userId: String, photoUrl: URL, displayName: String, username: String, email: String) {
        self.userId = userId
        self.photoUrl = photoUrl
        self.displayName = displayName
        self.username = username
        self.email = email
        self.dateCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case photoUrl = "photo_url"
        case displayName = "display_name"
        case username
        case email
        case dateCreated = "date_created"
    }
    
}


protocol UserManagerProtocol {
    func createNewUser(user: DBUser) throws
    func isUserWithUsernameExistes(_ username: String) async throws -> Bool
    func isUserExists(userId: String) async throws -> Bool 
}

final class UserManager: UserManagerProtocol {

    private let userCollection = Firestore.firestore().collection("users")

    public func createNewUser(user: DBUser) throws {
        try userCollection.document(user.userId).setData(from: user, merge: false)
    }
    
    public func isUserWithUsernameExistes(_ username: String) async throws -> Bool {
        let snapshot = try await userCollection.whereField("username", isEqualTo: username).getDocuments()
        let documents = snapshot.documents
        return !documents.isEmpty
    }
    
    public func isUserExists(userId: String) async throws -> Bool {
        let snapshot = try await  userCollection.whereField("user_id", isEqualTo: userId).getDocuments()
        let documents = snapshot.documents
        return !documents.isEmpty
    }
    
}
