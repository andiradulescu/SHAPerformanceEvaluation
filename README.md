### CryptoKit is slower than CrytpoSwift
This is an example project to demonstrate that running SHA256 twice, as part of a simple [Proof-of-Work](https://en.wikipedia.org/wiki/Proof_of_work)(POW), is much slower using [CryptoKit](https://developer.apple.com/documentation/cryptokit/sha256) than [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).

The POW is super simple, it performs SHA256 twice on some input data (seed), until the SHA256 twice hashing results in a digest meeting some target number of leading zeros in it.

```swift
let seed: Data // input
let targetNumberOfLeadingZeros = 16

// number of iterations until threshold `targetNumberOfLeadingZeros` is met.
var nonce: Int64 = 0

var powData: Data!

repeat {
    nonce += 1
    let unhashed = seed + fourBytesFrom(int: nonce)
    powData = sha256TwiceHasher.sha256sha256(of: unhashed)
} while powData.numberOfLeadingZeroBits < targetNumberOfLeadingZeros

return nonce 
```

CryptoSwift version `1.0.0` has been imported into the project using Carthage.

**For the same test vectors using CryptoKit is around 40 - 80% slower than CryptoSwift.**

#### Optimization flags
Currently using `Fastest, Aggressive Optimizations` and `Optimize for Speed` flags.

#### Why Carthage?
However I included the build of CryptoSwift using Carthage in Git. So you ought to be able to run it. At first I imported CryptoSwift using SPM, but runtime CryptoSwift was much slower using SPM. Maybe I did something wrong, but it seemed it did not get build using optimization flags.
