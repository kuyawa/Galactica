//
//  AppDelegate.swift
//  Galactica
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let testAccount = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
    let storage     = Storage()
    let cache       = AppCache()

    override init() {
        print("Hello")
        super.init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("Goodbye")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

// END
