//
//  AppDelegate.swift
//  SHAOnDevice
//
//  Created by Alexander Cyon on 2019-08-18.
//  Copyright © 2019 Alex Cyon. All rights reserved.
//

import Cocoa
import SwiftUI
import SHAPerformanceEvaluation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")

        window.contentView = NSHostingView(rootView: ContentView())

        window.makeKeyAndOrderFront(nil)

        let slowestVector = vectorsSlow[0]
        powInBackground(hasher: CryptoSwiftSha256Twice(), vector: slowestVector) { [weak self] timeForCryptoSwift in
            self?.powInBackground(hasher: CryptoKitSha256Twice(), vector: slowestVector) { timeForCryptoKit in
                let rate = timeForCryptoKit / timeForCryptoSwift
                print(String(format: "POW using CryptoKit takes %.2f x as long time", rate))
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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
