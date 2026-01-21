//
//  ResourceLoader.swift
//  Bitcoin
//
//  Created by mac on 2026/1/17.
//


import Foundation

public enum ResourceLoader_V1 {
    
    public static func url(
        name: String,
        ext: String,
        subdirectory: String? = nil
    ) -> URL? {
        #if SWIFT_PACKAGE
        return Bundle.module.url(forResource: name, withExtension: ext, subdirectory: subdirectory)
        #else
        
        let bundle = Bundle(for: BundleToken_V1.self)
        return bundle.url(forResource: name, withExtension: ext, subdirectory: subdirectory)
        #endif
    }
}


private final class BundleToken_V1 {}
