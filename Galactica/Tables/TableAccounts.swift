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

class TableAccounts: NSObject, NSTableViewDataSource, NSTableViewDelegate {  //, NSPasteboardWriting {

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
/*
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        print("Copy2")
        guard row >= 0, row < list.count else { return nil }
        let textCopy = list[row].key
        let copyItem = NSPasteboardItem()
        copyItem.setString(textCopy, forType: NSPasteboardTypeString)
        return copyItem
    }
     
    func writableTypes(for pasteboard: NSPasteboard) -> [String] {
        return [NSPasteboardTypeString]
    }
     
    func pasteboardPropertyList(forType type: String) -> Any? {
        return "Hello"
    }


    // Copies public key to clipboard
    func copy(_ sender: AnyObject?) {
        print("Copy")
        guard let index = tableView?.selectedRow, index >= 0, index < list.count else { return }
        let textCopy = list[index].key
        let pasteBoard = NSPasteboard.general()
        pasteBoard.clearContents()
        pasteBoard.setString(textCopy, forType: NSPasteboardTypeString)
    }
    
    //func cut(_ sender: AnyObject?) {}


    func copy(sender: AnyObject?) {
        print("Copy3")
        guard let index = tableView?.selectedRow, index >= 0, index < list.count else { return }
        let textCopy = list[index].key
        let pasteBoard = NSPasteboard.general()
        pasteBoard.clearContents()
        pasteBoard.setString(textCopy, forType: NSPasteboardTypeString)
    }
    func copy(sender: Any?) {
        print("Copy4")
        guard let index = tableView?.selectedRow, index >= 0, index < list.count else { return }
        let textCopy = list[index].key
        let pasteBoard = NSPasteboard.general()
        pasteBoard.clearContents()
        pasteBoard.setString(textCopy, forType: NSPasteboardTypeString)
    }
    
    func copy(_ sender: Any?) {
        print("Copy5")
        guard let index = tableView?.selectedRow, index >= 0, index < list.count else { return }
        let textCopy = list[index].key
        let pasteBoard = NSPasteboard.general()
        pasteBoard.clearContents()
        pasteBoard.setString(textCopy, forType: NSPasteboardTypeString)
    }
*/
    
}

// END
