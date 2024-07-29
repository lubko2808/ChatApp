//
//  StorageManager.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.06.2024.
//

import FirebaseStorage
import UIKit

protocol ProfileImageUploader {
    func uploadProfileImage(_ image: UIImage, userId: String) async throws -> URL
}

protocol ProfileImageFetcher {
    func getProfileImage(userId: String) async throws -> UIImage
}

final class StorageManager: ProfileImageUploader, ProfileImageFetcher {
    
    private let cacheManager = CacheManager.shared
    
    enum StorageManagerError: LocalizedError {
        case couldNotCreateImage
        case couldNotFetchImage
        
        var errorDescription: String? {
            switch self {
            case .couldNotFetchImage:
                return "Could not fetch profile image"
            case .couldNotCreateImage:
                return "Could not create profile image"
            }
        }
    }
    
    enum Constants {
        static let tenMb: Int64 = 10 * 1024 * 1024
    }

    private var task: StorageDownloadTask? = nil
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
        let path = "profileImage/\(userId).jpg"
        
        if let cachedImage = cacheManager.get(key: path) {
            return cachedImage
        }
        let storageRef = storage.reference().child(path)
        let imageData = try await storageRef.getDataCancallable(maxSize: Constants.tenMb)
        guard let image = UIImage(data: imageData) else {
            throw StorageManagerError.couldNotCreateImage
        }
        cacheManager.add(key: path, value: image)
        return image
    }
}
