//
//  AccountCellView.swift
//  StellarPlay
//
//  Created by Laptop on 1/30/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

class AssetCellView: NSTableCellView {

    @IBOutlet weak var textSymbol : NSTextField!
    @IBOutlet weak var textIssuer : NSTextField!
    @IBOutlet weak var textAmount : NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
