//
//  TableOperations.swift
//  Galactica
//
//  Created by Laptop on 2/1/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class TableOperations: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var app = NSApp.delegate as! AppDelegate
    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [StellarSDK.OperationResponse] = []
    var selected = 0
    var address  = ""
    
    func load(from: Storage.AccountData, onReady: @escaping Completion) {
        address = from.key
        let network: StellarSDK.Horizon.Network = (from.net == "Test" ? .test : .live)
        let account = StellarSDK.Account(address, network)
        
        account.getOperations(cursor: nil, limit: 20, order: .desc) { response in
            self.app.log("Operations:", response.raw ?? "?")
            if response.error != nil {
                onReady(response.error!.text)
                return
            }
            DispatchQueue.main.async {
                self.list = response.records
                self.tableView?.target     = self
                self.tableView?.delegate   = self
                self.tableView?.dataSource = self
                self.tableView?.reloadData()
                onReady("Operations loaded")
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        
        let item   = list[row]
        let cellId = column.identifier
        
        var text = ""

        switch item.typeInt {
        case 0: /* Create account */
            switch cellId {
            case "textDate"   : text = item.createdAt?.dateISO.string ?? ""; break
            case "textId"     : text = item.typeText; break
            case "textFrom"   : text = item.funder ?? ""; break
            case "textTo"     : text = item.sourceAccount ?? ""; break
            case "textAmount" : text = item.startingBalance?.money ?? ""; break
            case "textAsset"  : text = "XLM"; break
            default           : text = "" }
            break
        default: /* Payment */
            switch cellId {
            case "textDate"   : text = item.createdAt?.dateISO.string ?? ""; break
            case "textId"     : text = item.typeText; break
            case "textFrom"   : text = item.from ?? ""; break
            case "textTo"     : text = item.to   ?? ""; break
            case "textAmount" : text = item.amount?.money ?? ""; break
            case "textAsset"  : text = (item.assetType == "native" ? "XLM" : item.assetCode) ?? ""; break
            default           : text = "" }
            break
        }
        
        if let cell = tableView.make(withIdentifier: cellId, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text
            
            if cellId == "textAmount" {
                if item.typeInt == 1 && item.sourceAccount == address {
                    cell.textField?.textColor = NSColor(hex: 0x800000)
                } else {
                    cell.textField?.textColor = NSColor(hex: 0x008800)
                }
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
