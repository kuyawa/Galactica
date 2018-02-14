//
//  LogWindow.swift
//  Galactica
//
//  Created by Laptop on 2/13/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

class LogWindow: NSWindowController {

    @IBOutlet var textLog: NSTextView!
    
    convenience init() {
        self.init(windowNibName: "LogWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        //print("Console loaded")
    }

    func log(_ args: [Any]) {
        guard textLog != nil, textLog.textStorage != nil else { return }
        var text = "\n"
        
        for item in args {
            print(item)
            if let str = item as? String {
                text.append(str+"\n")
            } else {
                text.append("\(item)\n")
            }
        }
        
        //textLog.textStorage!.append(text)
        textLog.string?.append(text)
        textLog.font = NSFont(name: "Monaco", size: 12.0)
    }
}
