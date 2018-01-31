//
//  TableAccounts.swift
//  StellarPlay
//
//  Created by Laptop on 1/30/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa

//extension ViewController : NSTableViewDataSource {
class TableAccounts: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    var tableView: NSTableView?
    var tableSelection: () -> () = {}
    var listAccounts: [Storage.AccountData] = []
    var selectedAccount = 0
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return listAccounts.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item   = listAccounts[row]
        let cellId = "accountCell"
        //print(tableView.identifier)
        
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
            self.selectedAccount = sel
            tableSelection()
        }
    }
    
    func selectFirstRow() {
        if let nrows = tableView?.numberOfRows, nrows > 0 {
            tableView?.selectRowIndexes([0], byExtendingSelection: false)
        }
    }
    

}
