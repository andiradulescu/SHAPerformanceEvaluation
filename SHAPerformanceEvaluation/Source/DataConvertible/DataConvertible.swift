//
//  DataConvertible.swift
//  SHAPerformanceEvaluation
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation
//import CryptoSwift

public protocol DataConvertible {
    var asData: Data { get }
}

public extension BinaryInteger {
    var asData: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Self>.size)
    }
}

extension Data: DataConvertible {
    public var asData: Data { self }
}
extension Int: DataConvertible {}
extension UInt32: DataConvertible {}
extension UInt64: DataConvertible {}


// MARK: Data + NumberOfLeadingZeroBits
internal extension DataConvertible {

    var bytes: [UInt8] {
        return [UInt8](asData)
    }

    var numberOfLeadingZeroBits: Int {
        let byteArray = self.bytes
        let bitsPerByte = 8
        guard let index = byteArray.firstIndex(where: { $0 != 0 }) else {
            return byteArray.count * bitsPerByte
        }

        // count zero bits in byte at index `index`
        return index * bitsPerByte + byteArray[index].leadingZeroBitCount
    }
}

// MARK: Data + ExpressibleByStringLiteral
extension Data: ExpressibleByStringLiteral {
    public init(stringLiteral hexString: String) {
        self.init(hex: hexString)
    }
}
