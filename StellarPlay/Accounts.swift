//
//  Accounts.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import StellarSDK


extension ViewController {
   
    @IBAction func onGenerating(_ sender: Any) {
        generateKeypair()
    }
    
    @IBAction func onFunding(_ sender: Any) {
        fundAccount()
    }
    
    @IBAction func onSaving(_ sender: AnyObject) {
        saveAccount()
    }
    
    @IBAction func onNetwork(_ sender: Any) {
        //
    }
    
    @IBAction func onDeleting(_ sender: Any) {
        deleteAccount()
    }
    


    func generateKeypair() {
        let keyPair = KeyPair.random()
        textAddress.stringValue = keyPair.publicKey.base32
        textSecret.stringValue  = keyPair.secretKey.base32
    }
    
    func fundAccount() {
        if buttonNetwork.selectedSegment == 0 {
            // Message: only accounts in test network can be funded
            showStatus("Only accounts in test network can be funded")
            buttonNetwork.setSelected(true, forSegment: 1)
        }
        
        let address = textAddress.stringValue
        if address.isEmpty {
            showStatus("Public key is required")
            return
        }
        
        let server  = StellarSDK.Horizon.test
        showStatus("Funding account on test network, please wait...")
        server.friendbot(address: address) { response in
            print("Raw:", response.raw)
            var message = "Account funded"
            if let status = response.json["status"] as? Int, status == 400 {
                message = "Error funding account. Try again later"
            }
            DispatchQueue.main.async { self.showStatus(message) }
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
            showStatus("Public key is required")
            return
        }
        
        let account = Storage.AccountData(key: publicKey, sec: secretKey, net: network, name: name)
        accountsController.list.append(account)
        app.storage.accounts.append(account)
        app.storage.saveAccounts()
        showStatus("Account saved")
        
        if checkSecret.state == 0 && !secretKey.isEmpty {
            //Keychain.save(publicKey, secretKey)
        }
        
        refreshAccounts = true
    }
    
    func deleteAccount() {
        // TODO: Delete selected account
        let selected = tableAccounts.selectedRow
        if selected < 0 || selected > app.storage.accounts.count {
            showStatus("Select an account first")
            return
        }
        
        // Alert!
        // If ok:
        let account = app.storage.accounts[selected]
        Keychain.delete(account.key)                // Remove from keychain
        app.storage.accounts.remove(at: selected)   // Remove from storage list
        app.storage.saveAccounts()                  // Remove from user defaults
        accountsController.list = app.storage.accounts
        accountsController.selectFirstRow()         // Select same index in accounts list
        tableAccounts.reloadData()
        // If no accounts, add test account
        
        showStatus("Account deleted")
    }

}
