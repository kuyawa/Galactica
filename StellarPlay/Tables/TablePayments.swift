//
//  TablePayments.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class TablePayments: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [StellarSDK.PaymentResponse] = []
    var selected = 0
    
    func loadPayments(address: String, network: StellarSDK.Horizon.Network?) {
        let account = StellarSDK.Account(address, network)
        account.getPayments(cursor: nil, limit: 20, order: .desc) { payments in
            if payments.error != nil {
                // TODO: Nice message
                print(payments.error!.text)
                return
            }
            DispatchQueue.main.async {
                self.list = payments.records
                self.tableView?.target     = self
                self.tableView?.delegate   = self
                self.tableView?.dataSource = self
                self.tableView?.reloadData()
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
        //print(tableView.identifier)
        
        var text = ""

        switch cellId {
        case "textDate"   : text = item.createdAt?.dateISO.string ?? "?"; break
        case "textId"     : text = item.id?.ellipsis(10)   ?? "?"; break
        case "textFrom"   : text = item.from?.ellipsis(10) ?? "?"; break
        case "textTo"     : text = item.to?.ellipsis(10)   ?? "?"; break
        case "textAmount" : text = item.amount?.money ?? "?"; break
        case "textAsset"  : text = (item.assetType == "native" ? "XLM" : item.assetCode) ?? "?"; break
        default           : text = "?"
        }
/*
        switch cellId {
        case "textDate"   : text = item.createdAt?.date.string ?? "?"; break
        case "textId"     : text = item.id?.ellipsis(10)   ?? "?"; break
        case "textFrom"   : text = item.from?.ellipsis(10) ?? "?"; break
        case "textTo"     : text = item.to?.ellipsis(10)   ?? "?"; break
        case "textAmount" : text = item.amount?.money ?? "?"; break
        case "textAsset"  : text = (item.assetType == "native" ? "XLM" : item.assetCode) ?? "?"; break
        default           : text = "?"
        }
*/
        if let cell = tableView.make(withIdentifier: cellId, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text

            if cellId == "textAmount" {
                if item.typeInt == 1 {
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
