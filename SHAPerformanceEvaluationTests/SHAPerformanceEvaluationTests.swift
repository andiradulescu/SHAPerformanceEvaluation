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
