//
//  StorageReference+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 28.07.2024.
//

import FirebaseStorage
import Foundation

public extension StorageReference {
    
    class Holder<T> {
        var value: T?
    }
    
    func getDataCancallable(maxSize: Int64) async throws -> Data {
        let holder: Holder<StorageDownloadTask> = .init()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                holder.value = self.getData(maxSize: maxSize) { result in
                    continuation.resume(with: result)
                }
            }
        } onCancel: {
            holder.value?.cancel()
        }
    }
    
}
