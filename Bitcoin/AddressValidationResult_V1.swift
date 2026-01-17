//
//  AddressValidationResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// Address validation result data model
/// Used to receive address validation results from JS
public struct AddressValidationResult_V1: Codable {
    /// Whether the address is valid
    public let isValid: Bool
    
    /// Address type: p2pkh, p2sh, p2wpkh, p2wsh, p2tr, legacy, unknown
    public let type: String
    
    /// Network type: mainnet, testnet, unknown
    public let network: String
    
    public init(isValid: Bool, type: String, network: String) {
        self.isValid = isValid
        self.type = type
        self.network = network
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dictionary: [String: Any]) {
        guard let isValid = dictionary["isValid"] as? Bool,
              let type = dictionary["type"] as? String,
              let network = dictionary["network"] as? String else {
            return nil
        }
        
        self.isValid = isValid
        self.type = type
        self.network = network
    }
    
    /// Get address type display name
    public var typeDisplayName: String {
        switch type {
        case "p2pkh": return "P2PKH (Legacy)"
        case "p2sh": return "P2SH (Script Hash)"
        case "p2wpkh": return "P2WPKH (Segwit)"
        case "p2wsh": return "P2WSH (Segwit Script)"
        case "p2tr": return "P2TR (Taproot)"
        case "legacy": return "Legacy"
        case "unknown": return "Unknown Type"
        default: return type
        }
    }
    
    /// Get network type display name
    public var networkDisplayName: String {
        switch network {
        case "mainnet": return "Mainnet"
        case "testnet": return "Testnet"
        case "unknown": return "Unknown Network"
        default: return network
        }
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
    public static func fromJSONString(_ jsonString: String) -> AddressValidationResult_V1? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(AddressValidationResult_V1.self, from: data)
        } catch {
            return nil
        }
    }
}

