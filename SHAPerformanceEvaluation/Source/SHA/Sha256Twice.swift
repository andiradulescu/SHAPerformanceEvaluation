//
//  SHA.swift
//  SHAPerformanceEvaluation
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoSwift

// MARK: - SHA256 Twice
public protocol Sha256Twice {
    func sha256sha256(of data: Data) -> [UInt8]
    var nameOfHasher: String { get }
}

// MARK: CryptoKit
public struct CryptoKitSha256Twice: Sha256Twice {
    public init() {}
    public func sha256sha256(of data: Data) -> [UInt8] {
        var hasher1 = SHA256()
        data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            hasher1.update(bufferPointer: bufferPointer)
        }
        let digest1 = hasher1.finalize()
        
        var hasher2 = SHA256()
        digest1.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            hasher2.update(bufferPointer: bufferPointer)
        }
        let digest2 = hasher2.finalize()
        
        var data: [UInt8] = []
        digest2.withUnsafeBytes {
            data.append(contentsOf: $0)
        }
                
        return data
    }
    public var nameOfHasher: String { "CryptoKit" }
}

// MARK: CryptoSwift
public struct CryptoSwiftSha256Twice: Sha256Twice {
    public init() {}
}

public extension CryptoSwiftSha256Twice {

    func sha256sha256(of data: Data) -> [UInt8] {
        let zero = Array<UInt8>(data)
        let once = CryptoSwift.SHA2(variant: .sha256).calculate(for: zero)
        let twice = CryptoSwift.SHA2(variant: .sha256).calculate(for: once)
        return twice
    }

    var nameOfHasher: String { "CryptoSwift" }
}


