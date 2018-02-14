//
//  TableAccounts.swift
//  Galactica
//
//  Created by Laptop on 1/30/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa


class AccountCellView: NSTableCellView {
   
    @IBOutlet weak var textName    : NSTextField!
    @IBOutlet weak var textAddress : NSTextField!
    @IBOutlet weak var textNetwork : NSTextField!
    
}

class TableAccounts: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [Storage.AccountData] = []
    var selected = 0
    

    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item   = list[row]
        let cellId = "accountCell"
        
        if let cell = tableView.make(withIdentifier: cellId, owner: nil) as? AccountCellView {
            cell.textName?.stringValue    = item.name
            cell.textAddress?.stringValue = item.key
            cell.textNetwork?.stringValue = item.net
            
            if item.net == "Test" {
                cell.textNetwork?.textColor = NSColor.red
            } else {
                cell.textNetwork?.textColor = NSColor.green
            }
            
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
