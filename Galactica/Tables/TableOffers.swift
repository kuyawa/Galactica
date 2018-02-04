//
//  TableOffers.swift
//  Galactica
//
//  Created by Laptop on 2/1/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class TableOffers: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var tableView: NSTableView?
    var tableSelection: (_ selected: Int) -> () = { index in }
    var list: [StellarSDK.OfferResponse] = []
    var selected = 0
    var address  = ""
    
    func load(from: Storage.AccountData, onReady: @escaping Completion) {
        address = from.key
        let network: StellarSDK.Horizon.Network = (from.net == "Test" ? .test : .live)
        let account = StellarSDK.Account(address, network)
        
        account.getOffers(cursor: nil, limit: 20, order: .desc) { response in
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
                onReady("Offers loaded")
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
        //case "textDate"    : text = item.createdAt?.dateISO.string ?? "?"; break
        case "textId"      : text = item.id?.str ?? "?"; break
        case "textSeller"  : text = item.seller ?? "?"; break
        case "textSelling" : text = (item.selling?.assetType == "native" ? "XLM" : item.selling?.assetCode) ?? "?"; break
        case "textBuying"  : text = (item.buying?.assetType  == "native" ? "XLM" : item.buying?.assetCode) ?? "?"; break
        case "textPrice"   : text = item.price?.money ?? "?"; break
        case "textAmount"  : text = item.amount?.money ?? "?"; break
        default            : text = "?"
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
