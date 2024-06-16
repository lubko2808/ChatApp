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
    
    enum StorageManagerError: Error {
        case couldNotCreateImage
    }

    private let storage = Storage.storage()
    
    public func uploadProfileImage(_ image: UIImage, userId: String) async throws -> URL {
        let storageRef = storage.reference().child("profileImage/\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageData = image.pngData()
        let _ = try await storageRef.putDataAsync(imageData ?? Data(), metadata: metadata)
        let url = try await storageRef.downloadURL()
        return url
    }
    
    public func getProfileImage(userId: String) async throws -> UIImage {
        let storageRef = storage.reference().child("profileImage/\(userId).jpg")
        let imageData = try await storageRef.data(maxSize: 10 * 1024 * 1024)
        guard let image = UIImage(data: imageData) else {
            throw StorageManagerError.couldNotCreateImage
        }
        return image
    }
    
}
