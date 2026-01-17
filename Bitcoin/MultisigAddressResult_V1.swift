//
//  MultisigAddressResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// Multisig address generation result (non-Taproot address)
public struct MultisigAddressResult_V1: Codable {
    /// Multisig script
    public let script: String
    
    /// P2SH address (Legacy)
    public let p2shAddress: String
    
    /// P2WSH address (Segwit)
    public let p2wshAddress: String
    
    /// Threshold number (Threshold N)
    public let threshold: Int
    
    /// Total number of signers (Total Signers M)
    public let totalSigners: Int
    
    public init(script: String, p2shAddress: String, p2wshAddress: String, threshold: Int, totalSigners: Int) {
        self.script = script
        self.p2shAddress = p2shAddress
        self.p2wshAddress = p2wshAddress
        self.threshold = threshold
        self.totalSigners = totalSigners
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dict: [String: Any]) {
        guard let script = dict["script"] as? String,
              let p2shAddress = dict["p2shAddress"] as? String,
              let p2wshAddress = dict["p2wshAddress"] as? String,
              let threshold = dict["threshold"] as? Int,
              let totalSigners = dict["totalSigners"] as? Int else {
            return nil
        }
        
        self.script = script
        self.p2shAddress = p2shAddress
        self.p2wshAddress = p2wshAddress
        self.threshold = threshold
        self.totalSigners = totalSigners
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
    public static func fromJSONString(_ jsonString: String) -> MultisigAddressResult_V1? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(MultisigAddressResult_V1.self, from: data)
        } catch {
            return nil
        }
    }
}

