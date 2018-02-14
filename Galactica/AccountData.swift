//
//  AccountData.swift
//  Galactica
//
//  Created by Laptop on 2/13/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import Cocoa


class AccountDataController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    typealias DataPair = (key: String, val: String)
    let EmtpyDataPair = DataPair(key:"", val:"")
    var dixy = [String: String]()
    var tableData = [DataPair]()
    var selected: DataPair? = nil
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        if let window = self.view.window {
            window.delegate = self
            //window.styleMask.remove(.resizable)    // Non resizeable
            window.styleMask.remove(.fullScreen)     // Non maximizeable
            window.styleMask.remove(.miniaturizable) // Non minimizeable
            
            loadData()
        }
    }
    
    func setData(_ data: [String: String]) {
        self.dixy = data
    }
    
    func loadData() {
        tableData.removeAll()
            
        for (key, val) in dixy {
            tableData.append((key: key, val:val))
        }
        
        tableView?.target     = self
        tableView?.dataSource = self
        tableView?.delegate   = self
        tableView?.reloadData()
    }
    
    func getSelectedItem() -> DataPair? {
        let index = tableView.selectedRow
        if index < 0 || index >= tableData.count { return nil }
        return tableData[index]
    }

    
    //---- TableView
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        
        let item   = tableData[row]
        let cellId = column.identifier
        
        var text = ""
        //print("Cell", cellId, item)
        switch cellId {
        case "cellKey"  : text = item.key; break
        case "cellValue": text = item.val; break
        default:        text = ""; break
        }
        
        if let cell = tableView.make(withIdentifier: cellId, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }

        return nil
    }
}


extension AccountDataController : NSWindowDelegate {
    func windowShouldClose(_ sender: Any) -> Bool {
        // This method is called form the red button in the window bar
        // Return false to avoid closing it
        // print("Should close")
        self.selected = getSelectedItem()
        return true
    }
    
    func windowWillClose(_ notification: Notification) {
        // This method is called from anywhere after the window is closed
        // print("Will close")
        // self.view.window?.close()
        let app = NSApplication.shared()
        app.stopModal()
    }
}

// END
