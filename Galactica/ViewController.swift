//
//  ViewController.swift
//  Galactica
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


class ViewController: NSViewController, NSTextDelegate, NSTabViewDelegate  {

    var app = NSApp.delegate as! AppDelegate
    var selectedAccount = 0
    var refreshAccounts = false
    var refreshLedger   = false
    
    // Table controllers
    var accountsController     = TableAccounts()
    var assetsController       = TableAssets()
    var paymentsController     = TablePayments()
    var operationsController   = TableOperations()
    var transactionsController = TableTransactions()
    var effectsController      = TableEffects()
    var offersController       = TableOffers()
    
    
    //---- OUTLETS
    
    // Main view
    @IBOutlet weak var labelAccounts : NSTextField!
    @IBOutlet weak var labelGenerate : NSTextField!
    @IBOutlet weak var labelLedger   : NSTextField!
    @IBOutlet weak var textStatus    : NSTextField!
    @IBOutlet weak var qrcodePublic  : NSImageView!
    @IBOutlet weak var qrcodeSecret  : NSImageView!
    
    
    // TabViews
    @IBOutlet weak var tabMain   : NSTabView!
    @IBOutlet weak var tabLedger : NSTabView!

    // Tables
    @IBOutlet weak var tableAccounts     : NSTableView!
    @IBOutlet weak var tableAssets       : NSTableView!
    @IBOutlet weak var tablePayments     : NSTableView!
    @IBOutlet weak var tableOperations   : NSTableView!
    @IBOutlet weak var tableTransactions : NSTableView!
    @IBOutlet weak var tableEffects      : NSTableView!
    @IBOutlet weak var tableOffers       : NSTableView!
    
    // Generate address
    @IBOutlet weak var textName        : NSTextField!
    @IBOutlet weak var textAddress     : NSTextField!
    @IBOutlet weak var textSecret      : NSTextField!
    @IBOutlet weak var buttonNetwork   : NSSegmentedControl!
    @IBOutlet weak var buttonFriendbot : NSButton!
    @IBOutlet weak var checkSecret     : NSButton!
    
    // Payment
    @IBOutlet weak var popupAccounts   : NSPopUpButton!
    @IBOutlet weak var textPayAddress  : NSTextField!
    @IBOutlet weak var textPayAmount   : NSTextField!
    @IBOutlet weak var popupAssets     : NSPopUpButton!
    //BOutlet weak var textPayAsset    : NSTextField!
    @IBOutlet weak var textPayMemo     : NSTextField!
    @IBOutlet weak var buttonPayment   : NSButton!
    
    // Options
    @IBOutlet weak var popupSetAccount        : NSPopUpButton!
    @IBOutlet weak var checkAuthRequired      : NSButton!
    @IBOutlet weak var checkAuthRevocable     : NSButton!
    @IBOutlet weak var checkAuthImmutable     : NSButton!
    
    @IBOutlet weak var textSetInflation       : NSTextField!
    @IBOutlet weak var textAllowTrustAddress  : NSTextField!
    @IBOutlet weak var textAllowTrustAsset    : NSTextField!
    @IBOutlet weak var checkAllowTrustAuth    : NSButton!
    @IBOutlet weak var textChangeTrustAddress : NSTextField!
    @IBOutlet weak var textChangeTrustAsset   : NSTextField!
    @IBOutlet weak var textChangeTrustLimit   : NSTextField!
    @IBOutlet weak var textMergeAccount       : NSTextField!
    @IBOutlet weak var textHomeDomain         : NSTextField!
    @IBOutlet weak var textDataKey            : NSTextField!
    @IBOutlet weak var textDataValue          : NSTextField!
    @IBOutlet weak var textFundAddress        : NSTextField!
    @IBOutlet weak var textFundBalance        : NSTextField!
    
    @IBOutlet weak var buttonSetOptions       : NSButton!
    @IBOutlet weak var buttonSetInflation     : NSButton!
    @IBOutlet weak var buttonAllowTrust       : NSButton!
    @IBOutlet weak var buttonChangeTrust      : NSButton!
    @IBOutlet weak var buttonMerge            : NSButton!
    @IBOutlet weak var buttonHomeDomain       : NSButton!
    @IBOutlet weak var buttonSetData          : NSButton!
    @IBOutlet weak var buttonFund             : NSButton!
    
    
    //---- ACTIONS
    
    @IBAction func onTabAccounts(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 0)
        if refreshAccounts {
            loadAccounts()
            loadAssets(0) // First account
            refreshAccounts = false
        }
    }
    
    @IBAction func onTabGenerate(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 1)
    }
    
    // Not used? Remove
    @IBAction func onTabLedger(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 2)
        if let tab = tabLedger.selectedTabViewItem {
            let num = tabLedger.indexOfTabViewItem(tab)
            if num < 1 && paymentsController.list.count < 1 {
                let account = accountsController.list[selectedAccount]
                paymentsController.load(from: account) { message in
                    self.showStatus("Payments loaded")
                }
            }
        }
    }

    @IBAction func onTabPayment(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 3)
        loadAccountsPopup()
        // TODO: remove when done testing
        textPayAddress.stringValue = "GACNHBPK6ZC77G545PQSQ2V7RWS5SQ4W56E2DNRBMPDFEQBQMTEH3XFW"
    }
    
    @IBAction func onTabOptions(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 4)
        loadOptionsPopup()
        
        switch sender.tag {
        case 0: break
        case 1: textSetInflation.becomeFirstResponder(); break
        case 2: textAllowTrustAddress.becomeFirstResponder(); break
        case 3: textChangeTrustAddress.becomeFirstResponder(); break
        case 4: textDataKey.becomeFirstResponder(); break
        case 5: textFundAddress.becomeFirstResponder(); break
        default: break
        }
    }

    @IBAction func onSendPayment(_ sender: Any) {
        sendPayment()
    }
    
    @IBAction func onPayAccount(_ sender: Any) {
        let popup = sender as! NSPopUpButton
        let select = popup.selectedTag()
        loadAssetsPopup(select)  // Fill assets popup with available assets for that account
    }
    
    @IBAction func onSelectLedger(_ sender: AnyObject) {
        tabMain.selectTabViewItem(at: 2)             // Ledger tab
        tabLedger.selectTabViewItem(at: sender.tag)  // Selected tab
        if sender.tag == 0 && paymentsController.list.count < 1 { loadPayments() }
    }
    
    
    @IBAction func onAccountsRefresh(_ sender: Any) {
        loadAccounts()
        loadAssets(0)
    }
    
    @IBAction func onAssetsRefresh(_ sender: Any) {
        if selectedAccount < 0 || selectedAccount > accountsController.list.count-1 {
            return
        }
        loadAssets(selectedAccount)
    }
    
    @IBAction func onLedgerRefresh(_ sender: Any) {
        guard let tab = tabLedger.selectedTabViewItem else { return }
        let index = tabLedger.indexOfTabViewItem(tab)
        
        switch index {
        case 0: loadPayments(refresh: true); break
        case 1: loadOperations(refresh: true); break
        case 2: loadTransactions(refresh: true); break
        case 3: loadEffects(refresh: true); break
        case 4: loadOffers(refresh: true); break
        default: break
        }
    }
    

    //---- ACCOUNT OPTIONS
    
    @IBAction func onSetAccount(_ sender: Any) {
        //
    }
    
    @IBAction func onSetOptions(_ sender: Any) {
        self.setAuthorization()
    }
    
    @IBAction func onSetInflation(_ sender: Any) {
        self.setInflation()
    }
    
    @IBAction func onAllowTrust(_ sender: Any) {
        self.allowTrust()
    }
    
    @IBAction func onChangeTrust(_ sender: Any) {
        self.changeTrust()
    }
    
    @IBAction func onMergeAccounts(_ sender: Any) {
        self.mergeAccounts()
    }
    
    @IBAction func onHomeDomain(_ sender: Any) {
        self.setHomeDomain()
    }
    
    @IBAction func onSetData(_ sender: Any) {
        self.setAccountData()
    }
    
    @IBAction func onFundAccount(_ sender: Any) {
        self.fundAccount()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main()
    }

    
    //---- MAIN
    
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
        loadAssets(0) // First account
    }
    
    func loadAccountsPopup() {
        popupAccounts.removeAllItems()
        
        for item in app.storage.accounts {
            let title = item.name + " - " + item.key.subtext(from: 0, to: 10) + "..." + item.key.subtext(from: 46, to: 55)
            popupAccounts.addItem(withTitle: title)
        }
        
        // Assign index to tag for item selection
        for (index, item) in popupAccounts.itemArray.enumerated() {
            item.tag = index
        }
        
        popupAccounts.selectItem(at: 0)
        loadAssetsPopup(0)
    }
    
    func loadAssetsPopup(_ accountIndex: Int) {
        popupAssets.removeAllItems()
        
        let key = app.storage.accounts[accountIndex].key
        
        if let assets = app.cache.assets[key] {
            for asset in assets {
                if asset.symbol == "XLM" {
                    popupAssets.addItem(withTitle: "XLM")
                } else {
                    popupAssets.addItem(withTitle: asset.symbol + " - " + asset.issuer.subtext(from: 0, to: 10) + "...")
                }
            }
            
            // Assign index to tag for item selection
            for (index, item) in popupAssets.itemArray.enumerated() {
                item.tag = index
            }
        } else {
            loadAssets(accountIndex)
        }
        
        popupAssets.selectItem(withTitle: "XLM")
    }
    
    func loadOptionsPopup() {
        popupSetAccount.removeAllItems()
        
        for item in app.storage.accounts {
            let title = item.name + " - " + item.key.subtext(from: 0, to: 10) + "..." + item.key.subtext(from: 46, to: 55)
            popupSetAccount.addItem(withTitle: title)
        }
        
        // Assign index to tag for item selection
        for (index, item) in popupSetAccount.itemArray.enumerated() {
            item.tag = index
        }
        
        popupAccounts.selectItem(at: 0)
        loadAssetsPopup(0)
    }

    func loadAssets(_ selected: Int) {
        if selected < 0 || selected >= accountsController.list.count { return }
        
        selectedAccount = selected
        assetsLoading()
        
        let row = accountsController.list[selected]
        let net = row.net=="Test" ? StellarSDK.Horizon.Network.test : StellarSDK.Horizon.Network.live
        let account = StellarSDK.Account(row.key, net)
        
        account.getBalances { balances in
            var assets: [AssetData] = []
            print("Balances", balances)
            print("Count", balances.count)
            if balances.count < 1 {
                DispatchQueue.main.async {
                    self.showAssets(assets)
                    self.showWarning("Assets not found!")
                }
                return
            }
            
            for balance in balances {
                //print(balance.assetCode, balance.balance, balance.assetType)
                let asset = AssetData(symbol: balance.assetCode, issuer: balance.assetIssuer, amount: balance.balance)
                assets.append(asset)
            }
            
            self.app.cache.assets[row.key] = assets
            
            DispatchQueue.main.async {
                self.showAssets(assets)
                self.showStatus("Assets loaded")
            }
        }
    }

    func assetsLoading() {
        showStatus("Loading assets, please wait...")
        var assets: [AssetData] = []
        let asset = AssetData(symbol: "Loading...", issuer: "Wait while we fetch the data", amount: "")
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

        switch index {
        case 0: loadPayments(); break
        case 1: loadOperations(); break
        case 2: loadTransactions(); break
        case 3: loadEffects(); break
        case 4: loadOffers(); break
        default: break
        }
    }
    
    func showStatus(_ text: String, _ warn: Bool = false) {
        if warn { showWarning(text) } else { showMessage(text) }
    }
    
    func showMessage(_ text: String) {
        textStatus.stringValue = text
        textStatus.textColor = NSColor.black
    }
    
    func showWarning(_ text: String) {
        textStatus.stringValue = text
        textStatus.textColor = NSColor.red
    }
    
    func readyStatus(_ text: String) {
        textStatus.stringValue = "Ready"
        textStatus.textColor = NSColor.black
    }
    
    func clearStatus() {
        textStatus.stringValue = ""
    }
    
}
