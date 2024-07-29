//
//  QuerySnapshot+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 29.07.2024.
//

import FirebaseFirestore

extension QuerySnapshot {
    
    func data<T: Decodable>(as type: T.Type) -> [T] {
        self.documents.compactMap { queryDocumentSnapshot in
            try? queryDocumentSnapshot.data(as: type)
        }
    }
    
}
