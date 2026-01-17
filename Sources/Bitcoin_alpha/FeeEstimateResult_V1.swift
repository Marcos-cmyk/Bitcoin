//
//  FeeEstimateResult_V1.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import Foundation

/// Fee estimation result data model
/// Used to receive fee estimation results from JS
public struct FeeEstimateResult_V1: Codable {
    /// High fee rate (satoshis)
    public let high: Int64
    
    /// Medium fee rate (satoshis)
    public let medium: Int64
    
    /// Low fee rate (satoshis)
    public let low: Int64
    
    /// Transaction size (vBytes)
    public let size: Int
    
    /// Fee rate information (sat/vB)
    public let rates: FeeRates_V1
    
    public init(high: Int64, medium: Int64, low: Int64, size: Int, rates: FeeRates_V1) {
        self.high = high
        self.medium = medium
        self.low = low
        self.size = size
        self.rates = rates
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dictionary: [String: Any]) {
        guard let high = dictionary["high"] as? Int64,
              let medium = dictionary["medium"] as? Int64,
              let low = dictionary["low"] as? Int64,
              let size = dictionary["size"] as? Int,
              let ratesDict = dictionary["rates"] as? [String: Any],
              let rates = FeeRates_V1(from: ratesDict) else {
            return nil
        }
        
        self.high = high
        self.medium = medium
        self.low = low
        self.size = size
        self.rates = rates
    }
    
    /// High fee rate (BTC)
    public var highInBTC: Double {
        return Double(high) / 100_000_000.0
    }
    
    /// Medium fee rate (BTC)
    public var mediumInBTC: Double {
        return Double(medium) / 100_000_000.0
    }
    
    /// Low fee rate (BTC)
    public var lowInBTC: Double {
        return Double(low) / 100_000_000.0
    }
}

/// Fee rate information data model
public struct FeeRates_V1: Codable {
    /// High fee rate (sat/vB)
    public let high: Int
    
    /// Medium fee rate (sat/vB)
    public let medium: Int
    
    /// Low fee rate (sat/vB)
    public let low: Int
    
    public init(high: Int, medium: Int, low: Int) {
        self.high = high
        self.medium = medium
        self.low = low
    }
    
    /// Initialize from dictionary (for parsing JS returned data)
    public init?(from dictionary: [String: Any]) {
        guard let high = dictionary["high"] as? Int,
              let medium = dictionary["medium"] as? Int,
              let low = dictionary["low"] as? Int else {
            return nil
        }
        
        self.high = high
        self.medium = medium
        self.low = low
    }
}

