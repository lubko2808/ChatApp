//
//  StorageManager.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.06.2024.
//

import FirebaseStorage
import UIKit

protocol StorageManagerProtocol {
    func uploadProfileImage(_ image: UIImage, userId: String) async throws -> URL
}

final class StorageManager: StorageManagerProtocol {

    private let storage = Storage.storage()
    
    public func uploadProfileImage(_ image: UIImage, userId: String) async throws -> URL {
        let storageRef = Storage.storage().reference().child("profileImage/\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageData = image.pngData()
        let _ = try await storageRef.putDataAsync(imageData ?? Data(), metadata: metadata)
        let url = try await storageRef.downloadURL()
        return url
    }
    
}
