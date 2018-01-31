//
//  ViewController.swift
//  StellarPlay
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class ViewController: NSViewController, NSTextDelegate  {

    var app = NSApp.delegate as! AppDelegate
    //var listAccounts: [Storage.AccountData] = []
    var selectedAccount    = 0
    var accountsController = TableAccounts()
    var assetsController   = TableAssets()
    
    @IBOutlet weak var labelAccounts : NSTextField!
    @IBOutlet weak var labelGenerate : NSTextField!
    @IBOutlet weak var labelLedger   : NSTextField!
    @IBOutlet weak var tableAccounts : NSTableView!
    
    @IBOutlet weak var textAddress : NSTextField!
    @IBOutlet weak var textSecret  : NSTextField!
    
    @IBOutlet weak var tabMain: NSTabView!
    
    @IBAction func onTabAccounts(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 0)
    }
    
    @IBAction func onTabGenerate(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 1)
    }
    
    @IBAction func onTabLedger(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 2)
    }
    
    @IBAction func onGenerate(_ sender: Any) {
        generateKeypair()
    }
    
    @IBAction func onFunding(_ sender: Any) {
        fundAccount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main()
        //testAccountInfo()
        //testKeychain()
    }

    func main() {
        loadAccounts()
        showBalances(0) // First account
    }
    
    func loadAccounts(){
        app.storage.loadAccounts(app)
        accountsController.list           = app.storage.accounts
        accountsController.tableView      = tableAccounts
        accountsController.tableSelection = showBalances
        tableAccounts.delegate   = accountsController
        tableAccounts.dataSource = accountsController
        tableAccounts.target     = accountsController
        //tableAccounts.doubleAction = #selector(onSelectedAccount(_:))
        tableAccounts.reloadData()
        selectedAccount = 0
    }
    
    func showBalances(_ selected: Int) {
        if selectedAccount < 0 { return }
        let row = accountsController.list[selected]
        let net = row.net=="Test" ? StellarSDK.Horizon.Network.test : StellarSDK.Horizon.Network.live
        let account = StellarSDK.Account(row.key, net)
        account.getInfo { info in
            for balance in info.balances {
                print(balance.assetCode, balance.balance, balance.assetType)
            }
        }
    }
    
    func generateKeypair() {
        let keyPair = KeyPair.random()
        textAddress.stringValue = keyPair.publicKey.base32
        textSecret.stringValue  = keyPair.secretKey.base32
    }
    
    func testAccountInfo() {
        let keyPair   = KeyPair.random()
        let publicKey = keyPair.publicKey.base32
        let server    = StellarSDK.Horizon.test
        server.account(address: publicKey) { response in
            print("Raw:", response.text)
        }
        
    }
    
    func fundAccount() {
        let address = textAddress.stringValue
        let server  = StellarSDK.Horizon.test
        server.friendbot(address: address) { response in
            print("Raw:", response.text)
            let envelope = response.json["envelope_xdr"] as! String
            print("Env:", envelope)
            let data = Data(base64Encoded: envelope)!
            print("Data:", data.bytes)
            let info = String(xdr: data)
            print("Info:", info)
        }
    }
    
}

