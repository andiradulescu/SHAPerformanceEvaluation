//
//  AppDelegate.swift
//  SHAOnDevice-iOS
//
//  Created by Andrei Radulescu on 11/3/19.
//  Copyright © 2019 Radix DLT. All rights reserved.
//

import UIKit
import SHAPerformanceEvaluation_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let slowestVector = vectorsSlow[0]
        powInBackground(hasher: CryptoSwiftSha256Twice(), vector: slowestVector) { [weak self] timeForCryptoSwift in
            self?.powInBackground(hasher: CryptoKitSha256Twice(), vector: slowestVector) { timeForCryptoKit in
                let rate = timeForCryptoSwift / timeForCryptoKit
                print(String(format: "POW using CryptoKit is %.2fx faster", rate))
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private let dispatchQueue = DispatchQueue(
          label: "POW",
          qos: DispatchQoS(qosClass: .background, relativePriority: 1),
          attributes: .concurrent,
          autoreleaseFrequency: .workItem,
          target: nil
      )

}

private extension AppDelegate {
    func powInBackground(hasher sha256TwiceHasher: Sha256Twice, vector: Vector, done: ((CFAbsoluteTime) -> Void)? = nil) {
        let powWorker = POW(sha256TwiceHasher: sha256TwiceHasher)
        dispatchQueue.async {
            let start = CFAbsoluteTimeGetCurrent()
            powWorker.doWork(vector: vector) { nonce in
                DispatchQueue.main.sync {
                    let end = CFAbsoluteTimeGetCurrent()
                    let executionTime: CFAbsoluteTime = end - start
                    print(String(format: "POW using '%@' took %.3f seconds", sha256TwiceHasher.nameOfHasher, executionTime))
                    done?(executionTime)
                }
            }
        }
    }
}
