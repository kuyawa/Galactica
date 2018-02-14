//
//  Accounts.swift
//  Galactica
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


// Extension for Account Actions

extension ViewController {
   
    @IBAction func onGenerating(_ sender: Any) {
        generateKeypair()
    }
    
    @IBAction func onFunding(_ sender: Any) {
        fundTestAccount()
    }
    
    @IBAction func onSaving(_ sender: AnyObject) {
        saveAccount()
    }
    
    @IBAction func onNetwork(_ sender: Any) {
        buttonFriendbot.isEnabled = (buttonNetwork.selectedSegment == 1)
    }
    
    @IBAction func onDeleting(_ sender: Any) {
        deleteAccount()
    }
    
    func generateKeypair() {
        let account = StellarSDK.Account.random()
        textAddress.stringValue = account.publicKey
        textSecret.stringValue  = account.secretKey
        qrcodePublic.image = QRCode.generate(text: account.publicKey, size: 140)
        qrcodeSecret.image = QRCode.generate(text: account.secretKey, size: 140)
    }
    
    func fundTestAccount() {
        if buttonNetwork.selectedSegment == 0 {
            showWarning("Only accounts in test network can be funded by our friendly bot!")
            //buttonNetwork.setSelected(true, forSegment: 1)
            return
        }
        
        let address = textAddress.stringValue
        if address.isEmpty {
            showWarning("Public key is required!")
            return
        }
        
        showStatus("Funding account on test network, please wait...")
        buttonFriendbot.isEnabled = false
        
        let server  = StellarSDK.Horizon.test
        server.friendbot(address: address) { response in
            self.app.log("Raw:", response.raw)
            var message = "Account funded!"
            
            if let status = response.json["status"] as? Int, status == 400 {
                message = "Error funding account. Try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonFriendbot.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func saveAccount() {
        var name      = textName.stringValue
        let publicKey = textAddress.stringValue
        let secretKey = textSecret.stringValue
        let network   = buttonNetwork.selectedSegment == 0 ? "Live" : "Test"
        
        if name.isEmpty { name = "Cash Account" }
        if publicKey.isEmpty {
            // Message public key is required
            showWarning("Public key is required!")
            return
        }
        
        let account = Storage.AccountData(key: publicKey, sec: secretKey, net: network, name: name)
        accountsController.list.append(account)
        app.storage.accounts.append(account)
        app.storage.saveAccounts()
        showStatus("Account saved!")
        
        if checkSecret.state == 0 && !secretKey.isEmpty {
            Keychain.save(publicKey, secretKey)
        }
        
        refreshAccounts = true
    }
    
    func deleteAccount() {
        let selected = tableAccounts.selectedRow
        if selected < 0 || selected >= app.storage.accounts.count {
            showWarning("Select an account first!")
            return
        }
        
        // TODO: Alert! If ok then delete
        let account = app.storage.accounts[selected]
        Keychain.delete(account.key)                // Remove from keychain
        app.storage.accounts.remove(at: selected)   // Remove from storage list
        app.storage.saveAccounts()                  // Remove from user defaults
        accountsController.list = app.storage.accounts
        accountsController.selectFirstRow()         // Select same index in accounts list
        tableAccounts.reloadData()
        // If no accounts, add test account
        
        showStatus("Account deleted!")
    }
    
    func sendPayment() {
        clearStatus()
        let selAcct  = popupAccounts.selectedTag()
        let address  = textPayAddress.stringValue
        let amount   = textPayAmount.floatValue
        let selAsset = popupAssets.selectedTag()
        let memoText = textPayMemo.stringValue
        
        // Validation
        guard selAcct > -1 else { showWarning("Select your sending account"); return }
        guard selAcct < app.storage.accounts.count else { showWarning("Account out of range in storage"); return }
        guard !address.isEmpty else { showWarning("Address can not be empty"); return }
        guard amount > 0 else { showWarning("Amount must be greater than zero"); return }
        if memoText.characters.count > 28 { showWarning("Memo will be truncated to 28 characters") }
        
        // Source account
        let source = app.storage.accounts[selAcct]
        let secret = Keychain.load(source.key)
        
        guard let account = StellarSDK.Account.fromSecret(secret) else {
            showWarning("Invalid address in keychain, must rebuild keys")
            return
        }

        // Asset
        var asset  = Asset.Native
        var symbol = "XLM"
        var issuer = ""
        let assets = app.cache.assets[source.key] ?? []  // TODO: rethink, guard
        
        if selAsset > -1 && selAsset < assets.count {
            symbol = assets[selAsset].symbol
            issuer = assets[selAsset].issuer
            
            if symbol == "XLM" {
                asset = Asset.Native
            } else {
                asset  = Asset(assetCode: symbol, issuer: KeyPair.getPublicKey(issuer)!)! // TODO: guard
            }
        }

        buttonPayment.isEnabled = false
        showStatus("Sending payment, please wait...")

        account.useNetwork(source.net == "Live" ? .live : .test)
        account.payment(address: address, amount: amount, asset: asset, memo: memoText) { response in
            self.app.log("\nResponse", response.raw)
            var message = "Payment sent"
            
            if response.error {
                message = "Error sending payment, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonPayment.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
}


// END
