//
//  String+Extension.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 29.07.2024.
//

import Foundation

extension String {
    
    func generateStringSequence() -> [String] {
        /// E.g ) "Mark" => ["M", "Ma", "Mar", "Mark"]
        guard self.count > 0 else { return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        return sequences
    }

}
