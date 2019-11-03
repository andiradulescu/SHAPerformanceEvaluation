//
//  POW.swift
//  SHAPerformanceEvaluation
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Foundation

public struct POW {

    private let sha256TwiceHasher: Sha256Twice

    public init(sha256TwiceHasher: Sha256Twice) {
        self.sha256TwiceHasher = sha256TwiceHasher
    }
}

public extension POW {

    func doWork(vector: Vector, done: @escaping (Int64) -> Void) {
        doWork(seed: vector.seed, magic: vector.magic, targetNumberOfLeadingZeros: vector.zeros, done: done)
    }

     func doWork(
        seed: Data,
        magic: Int32,
        targetNumberOfLeadingZeros: Int,
        done: (Int64) -> Void
    ) {
        guard seed.count == 32 else {
            fatalError("Bad length of seed, did you hash it before")
        }

        var nonce: Int64 = 0
        let base: Data = toFourBigEndianBytes(int32: magic) + seed
        var powData: [UInt8]
        repeat {
            nonce += 1
            let unhashed = base + toEightBigEndianBytes(int64: nonce)
            powData = sha256TwiceHasher.sha256sha256(of: unhashed)
        } while numberOfLeadingZeroBits(byteArray: powData) < targetNumberOfLeadingZeros

        done(nonce)
    }
}

private func numberOfLeadingZeroBits(byteArray: [UInt8]) -> Int {
    let bitsPerByte = 8
    guard let index = byteArray.firstIndex(where: { $0 != 0 }) else {
        return byteArray.count * bitsPerByte
    }

    // count zero bits in byte at index `index`
    return index * bitsPerByte + byteArray[index].leadingZeroBitCount
}

// MARK: Endianess swap
private func toFourBigEndianBytes(int32: Int32) -> [UInt8] {
    let uint32 = UInt32(truncatingIfNeeded: int32)
    let swappedInt32 = CFSwapInt32HostToBig(uint32)
    let fourBytes = swappedInt32.bytes
    return fourBytes
}

private func toEightBigEndianBytes(int64: Int64) -> [UInt8] {
    let swappedInt64 = CFSwapInt64HostToBig(UInt64(int64))
    let eightBytes = swappedInt64.bytes
    return eightBytes
}
