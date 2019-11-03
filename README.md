### CryptoKit is slower than CryptoSwift
This is an example project to demonstrate that running SHA256 twice, as part of a simple [Proof-of-Work](https://en.wikipedia.org/wiki/Proof_of_work)(POW), is much slower using [CryptoKit](https://developer.apple.com/documentation/cryptokit/sha256) than [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).

### macOS
Running the example app on your mac yields ~60% slower using CryptoKit than CryptoSwift. When running on mac, read the results in the console.

```
POW using 'CryptoSwift' took 3.624 seconds
POW using 'CryptoKit' took 5.792 seconds
POW using CryptoKit takes 1.60 x as long time
```

Running the example app with Xcode 11.2 on macOS 10.15.1 yields ~2.1x faster using CryptoKit than CryptoSwift. With no changes to the example. Also CryptoSwift is faster. Reasons are unknown at the time of writing.
```
POW using 'CryptoSwift' took 3.424 seconds
POW using 'CryptoKit' took 1.612 seconds
POW using CryptoKit is 2.12x faster
```

Running the example app on the same system and removing the Data conversions in shasha256 yields 2.5x faster using CryptoKit than CryptoSwift. Also CryptoSwift is faster, removing the Data conversion.
```
POW using 'CryptoSwift' took 3.029 seconds
POW using 'CryptoKit' took 1.204 seconds
POW using CryptoKit is 2.52x faster
```


### POW
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
