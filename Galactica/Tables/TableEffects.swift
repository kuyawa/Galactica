//
//  TableEffects.swift
//  Galactica
//
//  Created by Laptop on 2/1/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class TableEffects: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var app = NSApp.delegate as! AppDelegate
    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [StellarSDK.EffectResponse] = []
    var selected = 0
    var address  = ""
    
    func load(from: Storage.AccountData, onReady: @escaping Completion) {
        address = from.key
        let network: StellarSDK.Horizon.Network = (from.net == "Test" ? .test : .live)
        let account = StellarSDK.Account(address, network)
        
        account.getEffects(cursor: nil, limit: 20, order: .desc) { response in
            self.app.log("Effects:", response.raw)
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
                onReady("Effects loaded")
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
        
        switch cellId {
        //case "textDate"    : text = item.createdAt?.dateISO.string ?? ""; break
        case "textId"      : text = item.id ?? ""; break
        case "textAccount" : text = item.account ?? ""; break
        case "textType"    : text = item.type ?? ""; break
        case "textAmount"  : text = item.amount?.money ?? ""; break
        case "textAsset"   : text = (item.assetType == "native" ? "XLM" : item.assetCode) ?? ""; break
        case "textIssuer"  : text = item.assetIssuer ?? ""; break
        default            : text = ""
        }
        
        if let cell = tableView.make(withIdentifier: cellId, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text
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
