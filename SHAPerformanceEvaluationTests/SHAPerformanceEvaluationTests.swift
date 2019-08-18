//
//  SHAPerformanceEvaluationTests.swift
//  SHAPerformanceEvaluationTests
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import XCTest
@testable import SHAPerformanceEvaluation

/// Comments about time are results from running on a 2016 Macbook Pro with maxed out hardware.
class SHAPerformanceEvaluationTests: XCTestCase {

    func testCryptoSwiftFastVectors() {
        measure { // ~0.15s
            doTestCryptoSwift(vectors: vectorsFast)
        }
    }

    // 50% slower than CryptoSwift
    func testCryptoKitFastVectors() {
        measure { // ~0.23s
            doTestCryptoKit(vectors: vectorsFast)
        }
    }


    func testCryptoSwiftSlowVectors() {
        measure { // ~16s (`measure` runs block 10 times => ~3 min runtime)
            doTestCryptoSwift(vectors: vectorsSlow)
        }
    }

    // 75% slower than CryptoSwift
    func testCryptoKitSlowVectors() {
        measure { // ~28s (`measure` runs block 10 times => ~5 min runtime)
            doTestCryptoKit(vectors: vectorsSlow)
        }
    }
}

private extension SHAPerformanceEvaluationTests {

    func doTestCryptoSwift(vectors: [Vector]) {
        doTestPOW(
            sha256Hasher: CryptoSwiftSha256Twice(),
            vectors: vectors
        )
     }

     func doTestCryptoKit(vectors: [Vector]) {
        doTestPOW(
            sha256Hasher: CryptoKitSha256Twice(),
            vectors: vectors
        )
     }

    func doTestPOW(sha256Hasher: Sha256Twice, vectors: [Vector]) {
        let powWorker = POW(sha256TwiceHasher: sha256Hasher)

        vectors.forEach { vector in
            powWorker.doWork(
                seed: vector.seed,
                magic: vector.magic,
                targetNumberOfLeadingZeros: vector.zeros
            ) { nonce in
                XCTAssertEqual(nonce, vector.expectedResultingNonce)
            }
        }
    }
}

private typealias Vector = (expectedResultingNonce: Int64, seed: Data, magic: Int32, zeros: Int)

private let vectorsSlow: [Vector] = [
    (
        expectedResultingNonce: 510190,
        seed: "887a9e87ecbcc8f13ea60dd732a3c115ea9478519ee3faac3be3ed89b4bbc535",
        magic: -1332248574,
        zeros: 16
    ),
    (
        expectedResultingNonce: 322571,
        seed: "46ad4f54098f18f856a2ff05df25f5af587bd4f6dfc1e3b4cb406ceb25c61552",
        magic: -1332248574,
        zeros: 16
    ),
    (
        expectedResultingNonce: 312514,
        seed: "f0f178d42ffe8fade8b8197782fd1ee72a4068d046d868806da7bfb1d0ffa7c1",
        magic: -1332248574,
        zeros: 16
    ),
    (
        expectedResultingNonce: 311476,
        seed: "a33a90d0422aa12b68d1de6c53e83ca049ab82b06efeb03cf6731231e82470ef",
        magic: -1332248574,
        zeros: 16
    ),
    (
        expectedResultingNonce: 285315,
        seed: "0519269eafbac3accba00cf6f7e93238aae1974a1e5439a58a6f53726a963095",
        magic: -1332248574,
        zeros: 16
    ),
    (
        expectedResultingNonce: 270233,
        seed: "34931f7c0522352426d9d95f1c5527fafffce55b13082ae3723dc89f3c3e6276",
        magic: -1332248574,
        zeros: 16
    )
]

private let vectorsFast: [Vector] = [
    (
        expectedResultingNonce: 9255,
        seed: "deadbeef00000000deadbeef00000000deadbeef00000000deadbeef00000000",
        magic: 12345,
        zeros: 14
    ),
    (
        expectedResultingNonce: 6825,
        seed: "deadbeef00000000deadbeef00000000deadbeef00000000deadbeef00000000",
        magic: 12345,
        zeros: 12
    ),
    (
        expectedResultingNonce: 198,
        seed: "deadbeef00000000deadbeef00000000deadbeef00000000deadbeef00000000",
        magic: 12345,
        zeros: 10
    )
]
