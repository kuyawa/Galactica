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
    
    let debug       = true
    let storage     = Storage()
    let cache       = AppCache()
    let console     = LogWindow(windowNibName: "LogWindow")
    let testAccount = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"  // Read-only mode

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func log(_ args: Any...) {
        if debug {
            DispatchQueue.main.async { self.console.log(args) }
        }
    }
}

// END
