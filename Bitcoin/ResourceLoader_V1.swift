//
//  ResourceLoader.swift
//  Bitcoin
//
//  Created by mac on 2026/1/17.
//


import Foundation

public enum ResourceLoader_V1 {
    /// - Parameters:
    ///   - name: 资源名（不含后缀）
    ///   - ext: 资源后缀（如 "json", "html", "txt"）
    ///   - subdirectory: 子目录（如 "Assets"），没有就传 nil
    public static func url(
        name: String,
        ext: String,
        subdirectory: String? = nil
    ) -> URL? {
        #if SWIFT_PACKAGE
        return Bundle.module.url(forResource: name, withExtension: ext, subdirectory: subdirectory)
        #else
        // 如果你的库不是 SPM，也不应该用 Bundle.main；应该用“库所在的 bundle”
        let bundle = Bundle(for: BundleToken_V1.self)
        return bundle.url(forResource: name, withExtension: ext, subdirectory: subdirectory)
        #endif
    }
}

/// 一个空类，用来定位“当前库所在 bundle”
private final class BundleToken_V1 {}
