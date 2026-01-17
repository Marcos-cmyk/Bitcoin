//
//  OneClickTransferResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// One-click transfer result data model
/// Used to receive transfer results from JS
public struct OneClickTransferResult_V1: Codable {
    /// Transaction ID
    public let txid: String
    
    /// Signed transaction hexadecimal string
    public let signedHex: String
    
    public init(txid: String, signedHex: String) {
        self.txid = txid
        self.signedHex = signedHex
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dictionary: [String: Any]) {
        guard let txid = dictionary["txid"] as? String,
              let signedHex = dictionary["signedHex"] as? String else {
            return nil
        }
        
        self.txid = txid
        self.signedHex = signedHex
    }
    
    /// Convert to JSON string
    public func toJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    /// Initialize from JSON string
    public static func fromJSONString(_ jsonString: String) -> OneClickTransferResult_V1? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(OneClickTransferResult_V1.self, from: data)
        } catch {
            return nil
        }
    }
}

