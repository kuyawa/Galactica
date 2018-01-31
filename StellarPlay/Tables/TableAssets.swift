//
//  TableAssets.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

struct AssetData {
    var symbol = ""
    var issuer = ""
    var amount = ""
}

class TableAssets: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [AssetData] = []
    var selected = 0
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item   = list[row]
        let cellId = "assetCell"
        //print(tableView.identifier)
        
        if let cell = tableView.make(withIdentifier: cellId, owner: nil) as? AssetCellView {
            cell.textSymbol?.stringValue = item.symbol
            cell.textIssuer?.stringValue = item.issuer
            cell.textAmount?.stringValue = item.amount
            
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let sel = tableView?.selectedRow {
            self.selected = sel
            tableSelection(sel)
        }
    }
    
    func selectFirstRow() {
        if let nrows = tableView?.numberOfRows, nrows > 0 {
            tableView?.selectRowIndexes([0], byExtendingSelection: false)
        }
    }
    
    
}

// END
