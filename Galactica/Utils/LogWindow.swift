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
        print("logWin loaded")
    }

    func log(_ args: Any...) {
        let list = [args]
        let text = NSMutableAttributedString()
        
        for item in list {
            text.append(NSAttributedString(string: String(describing: item) + "\n"))
        }
        
        if textLog != nil && textLog.textStorage != nil {
            textLog.textStorage!.append(text)
            textLog.font = NSFont(name: "Monaco", size: 12.0)
        }
    }
}
