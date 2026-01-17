//
//  HTLCAddressResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// HTLC address generation result
public struct HTLCAddressResult_V1: Codable {
    /// Generated P2WSH address
    public let address: String
    
    /// Redeem script
    public let redeemScript: String
    
    /// Lock height
    public let lockHeight: Int
    
    /// Secret preimage (Secret Hex)
    public let secretHex: String
    
    public init(address: String, redeemScript: String, lockHeight: Int, secretHex: String) {
        self.address = address
        self.redeemScript = redeemScript
        self.lockHeight = lockHeight
        self.secretHex = secretHex
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dict: [String: Any]) {
        guard let address = dict["address"] as? String,
              let redeemScript = dict["redeemScript"] as? String,
              let lockHeight = dict["lockHeight"] as? Int,
              let secretHex = dict["secretHex"] as? String else {
            return nil
        }
        
        self.address = address
        self.redeemScript = redeemScript
        self.lockHeight = lockHeight
        self.secretHex = secretHex
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
    public static func fromJSONString(_ jsonString: String) -> HTLCAddressResult_V1? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(HTLCAddressResult_V1.self, from: data)
        } catch {
            return nil
        }
    }
}

