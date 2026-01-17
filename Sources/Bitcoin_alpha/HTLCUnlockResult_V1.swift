//
//  HTLCUnlockResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// HTLC unlock and transfer result data model
public struct HTLCUnlockResult_V1: Codable {
    /// Transaction ID
    public let txid: String
    
    /// Signed transaction (HEX format)
    public let signedHex: String
    
    public init(txid: String, signedHex: String) {
        self.txid = txid
        self.signedHex = signedHex
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dict: [String: Any]) {
        guard let txid = dict["txid"] as? String,
              let signedHex = dict["signedHex"] as? String else {
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
    public static func fromJSONString(_ jsonString: String) -> HTLCUnlockResult_V1? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(HTLCUnlockResult_V1.self, from: data)
        } catch {
            return nil
        }
    }
}

