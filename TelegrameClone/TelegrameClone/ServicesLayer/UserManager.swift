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

extension DBUser {
    var keywordsForLookup: [String] {
        [self.displayName.generateStringSequence(), self.username.generateStringSequence()].flatMap { $0 }
    }
}

protocol UserManagerProtocol {
    func createNewUser(user: DBUser) throws
    func isUserWithUsernameExistes(_ username: String) async throws -> Bool
    func isUserExists(userId: String) async throws -> Bool 
    func getUser(userId: String) async throws -> DBUser
    func getUsers(with displayName: String) async throws -> [DBUser]
    func resetUserSearch()
    func getUsers(with displayName: String, limit: Int) async throws -> [DBUser]
}

final class UserManager: UserManagerProtocol {

    private let userCollection = Firestore.firestore().collection("users")
    private let currentUser = AuthenticationManager().getAuthenticatedUser()

    public func createNewUser(user: DBUser) throws {
        let document = userCollection.document(user.userId)
        try document.setData(from: user)
        document.updateData(["keywordsForLookup" : user.keywordsForLookup])
    }

    func updateAllUsers() async throws {
        let documents = try await userCollection.getDocuments().documents
        documents.forEach { document in
            let d = document.reference
            let u = try! document.data(as: DBUser.self)
            d.updateData(["keywordsForLookup" : u.keywordsForLookup])
        }
    }

    public func getUser(userId: String) async throws -> DBUser {
        try await userCollection.document(userId).getDocument(as: DBUser.self)
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
    
    public func getUsers(with displayName: String) async throws -> [DBUser] {
        let querySnapshot = try await userCollection.whereField("keywordsForLookup", arrayContains: displayName).getDocuments()
        let users = querySnapshot.data(as: DBUser.self)
        return users
    }
    
    private var lastDocument: DocumentSnapshot?
    
    public func resetUserSearch() {
        lastDocument = nil
    }
    
    public func getUsers(with displayName: String, limit: Int) async throws -> [DBUser] {
        guard let currentUser else { return []}
        var query = userCollection
            .whereField("keywordsForLookup", arrayContains: displayName)
            .whereField("user_id", isNotEqualTo: currentUser.uid)
            .order(by: "display_name")
            .limit(to: limit)

        if let lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        let snapshot = try await query.getDocuments()
        let users = snapshot.data(as: DBUser.self)
        self.lastDocument = snapshot.documents.last
        return users
    }

}
