//
//  ViewController.swift
//  StellarPlay
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class ViewController: NSViewController, NSTextDelegate, NSTabViewDelegate  {

    var app = NSApp.delegate as! AppDelegate
    var selectedAccount = 0
    
    // Table controllers
    var accountsController     = TableAccounts()
    var assetsController       = TableAssets()
    var paymentsController     = TablePayments()
    var operationsController   = TableOperations()
    var transactionsController = TableTransactions()
    var effectsController      = TableEffects()
    var offersController       = TableOffers()
    
    // Main view
    @IBOutlet weak var labelAccounts : NSTextField!
    @IBOutlet weak var labelGenerate : NSTextField!
    @IBOutlet weak var labelLedger   : NSTextField!

    // Tables
    @IBOutlet weak var tableAccounts     : NSTableView!
    @IBOutlet weak var tableAssets       : NSTableView!
    @IBOutlet weak var tablePayments     : NSTableView!
    @IBOutlet weak var tableOperations   : NSTableView!
    @IBOutlet weak var tableTransactions : NSTableView!
    @IBOutlet weak var tableEffects      : NSTableView!
    @IBOutlet weak var tableOffers       : NSTableView!
    

    // Generate address
    @IBOutlet weak var textAddress : NSTextField!
    @IBOutlet weak var textSecret  : NSTextField!
    
    
    // TabView
    @IBOutlet weak var tabMain   : NSTabView!
    @IBOutlet weak var tabLedger : NSTabView!
    
    @IBAction func onTabAccounts(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 0)
    }
    
    @IBAction func onTabGenerate(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 1)
    }
    
    @IBAction func onTabLedger(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 2)
        if let tab = tabLedger.selectedTabViewItem {
            let num = tabLedger.indexOfTabViewItem(tab)
            if num < 1 && paymentsController.list.count < 1 {
                let account = accountsController.list[selectedAccount]
                self.paymentsController.load(from: account)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main()
        //testAccountInfo()
        //testKeychain()
    }

    func main() {
        // Assign tables to controllers
        tabLedger.delegate = self
        paymentsController.tableView     = tablePayments
        operationsController.tableView   = tableOperations
        transactionsController.tableView = tableTransactions
        effectsController.tableView      = tableEffects
        offersController.tableView       = tableOffers
        
        // Load initial data
        loadAccounts()
        loadAssets(0) // First account
    }
    
    func loadAccounts(){
        app.storage.loadAccounts(app)
        accountsController.list           = app.storage.accounts
        accountsController.tableView      = tableAccounts
        accountsController.tableSelection = loadAssets
        tableAccounts.delegate            = accountsController
        tableAccounts.dataSource          = accountsController
        tableAccounts.target              = accountsController
        //tableAccounts.doubleAction = #selector(onSelectedAccount(_:))
        tableAccounts.reloadData()
        selectedAccount = 0
    }
    
    func loadAssets(_ selected: Int) {
        if selected < 0 || selected >= accountsController.list.count { return }
        assetsLoading()
        let row = accountsController.list[selected]
        let net = row.net=="Test" ? StellarSDK.Horizon.Network.test : StellarSDK.Horizon.Network.live
        let account = StellarSDK.Account(row.key, net)
        account.getBalances { balances in
            var assets: [AssetData] = []
            for balance in balances {
                print(balance.assetCode, balance.balance, balance.assetType)
                let asset = AssetData(symbol: balance.assetCode, issuer: balance.assetIssuer, amount: balance.balance)
                assets.append(asset)
            }
            DispatchQueue.main.async { self.showAssets(assets) }
        }
    }

    func loadPayments(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        let account = accountsController.list[selectedAccount]
        if refresh! || paymentsController.list.count < 1 {
            paymentsController.load(from: account)
        }
    }

    func loadOperations(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        let account = accountsController.list[selectedAccount]
        if refresh! || operationsController.list.count < 1 {
            operationsController.load(from: account)
        }
    }

    func loadTransactions(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        let account = accountsController.list[selectedAccount]
        if refresh! || transactionsController.list.count < 1 {
            transactionsController.load(from: account)
        }
    }
    
    func loadEffects(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        let account = accountsController.list[selectedAccount]
        if refresh! || effectsController.list.count < 1 {
            effectsController.load(from: account)
        }
    }
    
    func loadOffers(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        let account = accountsController.list[selectedAccount]
        if refresh! || offersController.list.count < 1 {
            offersController.load(from: account)
        }
    }
    
    func assetsLoading() {
        // Temp fix, rethink, use status abr
        var assets: [AssetData] = []
        let asset = AssetData(symbol: "Loading...", issuer: "Wait while we fetch the server", amount: "")
        assets.append(asset)
        showAssets(assets)
    }
    
    func showAssets(_ assets: [AssetData]) {
        assetsController.list           = assets
        assetsController.tableView      = tableAssets
        //assetsController.tableSelection = ??
        tableAssets.delegate            = assetsController
        tableAssets.dataSource          = assetsController
        tableAssets.target              = assetsController
        //tableAassets.doubleAction = #selector(onSelectedAccount(_:))
        tableAssets.reloadData()
        //selectedAsset = 0
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tab = tabViewItem else { return }
        let index = tabLedger.indexOfTabViewItem(tab)
        //print("Tab selected", index)
        
        switch index {
        case 0: loadPayments(); break
        case 1: loadOperations(); break
        case 2: loadTransactions(); break
        case 3: loadEffects(); break
        case 4: loadOffers(); break
        default: break
        }
    }
    
}

