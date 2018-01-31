//
//  AccountCellView.swift
//  StellarPlay
//
//  Created by Laptop on 1/30/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

class AccountCellView: NSTableCellView {

    @IBOutlet weak var textName    : NSTextField!
    @IBOutlet weak var textAddress : NSTextField!
    @IBOutlet weak var textNetwork : NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
