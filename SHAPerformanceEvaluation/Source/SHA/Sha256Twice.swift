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
    func sha256sha256(of data: Data) -> Data
    var nameOfHasher: String { get }
}

// MARK: CryptoKit
public func cryptoKitSha256(of data: Data) -> Data {
    let digest = SHA256.hash(data: data)
    return Data(digest)
}

public struct CryptoKitSha256Twice: Sha256Twice {
    public init() {}
    public func sha256sha256(of data: Data) -> Data {
        let once = cryptoKitSha256(of: data)
        let twice = cryptoKitSha256(of: once)
        return twice
    }
    public var nameOfHasher: String { "CryptoKit" }
}

// MARK: CryptoSwift
//public func cryptoSwiftSha256(of data: Data) -> Data {
//    let bytes = Array<UInt8>(data)
//    let digest = .calculate(for: bytes)
//    return Data(digest)
//}

public struct CryptoSwiftSha256Twice: Sha256Twice {

//    private let hasher: CryptoSwift.SHA2

    public init() {}
}

public extension CryptoSwiftSha256Twice {

    func sha256sha256(of data: Data) -> Data {
        let zero = Array<UInt8>(data)
        let once = CryptoSwift.SHA2(variant: .sha256).calculate(for: zero)
        let twice = CryptoSwift.SHA2(variant: .sha256).calculate(for: once)
        return Data(twice)
    }

    var nameOfHasher: String { "CryptoSwift" }
}


