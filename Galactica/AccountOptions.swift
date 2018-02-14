//
//  AccountOptions.swift
//  Galactica
//
//  Created by Laptop on 2/10/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


// Extension for Account Options

extension ViewController {
  
    @IBAction func onSetAccount(_ sender: Any) {
        //
    }
    
    @IBAction func onSetOptions(_ sender: Any) {
        setAuthorization()
    }
    
    @IBAction func onSetInflation(_ sender: Any) {
        setInflation()
    }
    
    @IBAction func onAllowTrust(_ sender: Any) {
        allowTrust()
    }
    
    @IBAction func onChangeTrust(_ sender: Any) {
        changeTrust()
    }
    
    @IBAction func onMergeAccounts(_ sender: Any) {
        mergeAccounts()
    }
    
    @IBAction func onHomeDomain(_ sender: Any) {
        setHomeDomain()
    }
    
    @IBAction func onSetData(_ sender: Any) {
        setAccountData()
    }
    
    @IBAction func onViewData(_ sender: Any) {
        viewAccountData()
    }
    
    @IBAction func onFundAccount(_ sender: Any) {
        fundAccount()
    }
    

    func getPopupAccount() -> StellarSDK.Account? {
        let selAcct = popupSetAccount.selectedTag()
        
        guard selAcct > -1 else { showWarning("Select your account"); return nil }
        guard selAcct < app.storage.accounts.count else { showWarning("Account out of range in storage"); return nil }
        
        let source = app.storage.accounts[selAcct]
        let secret = Keychain.load(source.key)
        
        guard let account = StellarSDK.Account.fromSecret(secret) else {
            showWarning("Invalid address in keychain, must rebuild keys")
            return nil
        }
        
        account.useNetwork(source.net == "Live" ? .live : .test)
        
        return account
    }
    
    func setAuthorization() {
        guard let account = getPopupAccount() else { return }

        let flags = StellarSDK.AccountAuthorizationFlags(
                        required : checkAuthRequired.state.on,
                        revocable: checkAuthRevocable.state.on,
                        immutable: checkAuthImmutable.state.on)
        
        buttonSetOptions.isEnabled = false
        showStatus("Setting authorization, please wait...")

        account.setAuthorization(flags) { response in
            self.log("\nResponse", response.raw)
            var message = "Authorization has been set"
            
            if response.error {
                message = "Error setting authorization flags, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonSetOptions.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func setInflation() {
        guard let account = getPopupAccount() else { return }
        var destin = textSetInflation.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if destin.isEmpty { destin = account.publicKey }  // Can't reset inflation dest, use same account
        
        buttonSetInflation.isEnabled = false
        showStatus("Setting inflation destination, please wait...")
        
        account.setInflation(address: destin, memo: "Inflation") { response in
            self.log("\nResponse", response.raw)
            var message = "Inflation destination has been set"
            
            if response.error {
                message = "Error setting inflation destination, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonSetInflation.isEnabled = true
                self.showStatus(message, response.error)
            }
        }

    }
    
    func allowTrust() {
        guard let account = getPopupAccount() else { return }
        
        let address = textAllowTrustAddress.stringValue
        guard !address.isEmpty else { showWarning("Address can not be empty"); return }
        
        let issuer = account.publicKey
        let symbol = textAllowTrustAsset.stringValue
        guard !symbol.isEmpty else { showWarning("Asset can not be empty"); return }
        guard let asset = Asset(assetCode: symbol, issuer: issuer) else { showWarning("Invalid asset"); return }

        let authorize = (checkAllowTrustAuth.state == 0 ? false : true)
        
        buttonAllowTrust.isEnabled = false
        showStatus("Allowing asset trust, please wait...")
        
        account.allowTrust(address: address, asset: asset, authorize: authorize) { response in
            self.log("\nResponse", response.raw)
            var message = "Asset has been trusted!"
            
            if response.error {
                message = "Error trusting asset, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonAllowTrust.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func changeTrust() {
        guard let account = getPopupAccount() else { return }
        
        let issuer = textChangeTrustAddress.stringValue
        guard !issuer.isEmpty else { showWarning("Issuer address can not be empty"); return }
        
        let symbol = textChangeTrustAsset.stringValue
        guard !symbol.isEmpty else { showWarning("Asset can not be empty"); return }
        guard let asset = Asset(assetCode: symbol, issuer: issuer) else { showWarning("Invalid asset"); return }
        
        var limit = Int64.max  // Full trust
        if !textChangeTrustLimit.stringValue.isEmpty {
            limit = Int64(textChangeTrustLimit.integerValue)  // Limited trust
        }
        if textChangeTrustLimit.stringValue == "0" {
            limit = 0  // Remove trust
        }
        
        buttonChangeTrust.isEnabled = false
        showStatus("Changing asset trust, please wait...")
        
        account.changeTrust(asset: asset, limit: limit) { response in
            self.log("\nResponse", response.raw)
            var message = "Asset trust has been changed!"
            
            if response.error {
                message = "Error changing asset trust, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonChangeTrust.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func setHomeDomain() {
        guard let account = getPopupAccount() else { return }
        
        buttonHomeDomain.isEnabled = false
        showStatus("Setting home domain, please wait...")
        
        let url = textHomeDomain.stringValue
        
        account.setHomeDomain(url) { response in
            self.log("\nResponse", response.raw)
            var message = "Home domain has been set"
            
            if response.error {
                message = "Error setting home domain, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonHomeDomain.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func setAccountData() {
        guard let account = getPopupAccount() else { return }
        
        buttonSetData.isEnabled = false
        showStatus("Setting data value, please wait...")
        
        let key = textDataKey.stringValue
        let val = textDataValue.stringValue
        
        account.setData(key, val) { response in
            self.log("\nResponse", response.raw)
            var message = "Data value has been set"
            
            if response.error {
                message = "Error setting data value, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonSetData.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func mergeAccounts() {
        guard let account = getPopupAccount() else { return }
        
        let address = textAllowTrustAddress.stringValue
        guard !address.isEmpty else { showWarning("Address can not be empty"); return }
        
        buttonMerge.isEnabled = false
        showStatus("Merging accounts, please wait...")
        
        account.merge(address: address) { response in
            self.log("\nResponse", response.raw)
            var message = "Accounts have been merged!"
            
            if response.error {
                message = "Error merging accounts, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonMerge.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func fundAccount() {
        guard let account = getPopupAccount() else { return }
        
        let destin = textFundAddress.stringValue
        guard !destin.isEmpty else { showWarning("Destination address can not be empty"); return }
        
        let amount = Int64(textFundBalance.integerValue)
        guard amount > 0 else { showWarning("Starting balance must be greater than zero"); return }
        
        buttonFund.isEnabled = false
        showStatus("Funding account, please wait...")
        
        account.createAccount(address: destin, amount: amount, memo: "Funded by Galactica") { response in
            self.log("\nResponse", response.raw)
            var message = "Account has been funded!"
            
            if response.error {
                message = "Error funding account, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonFund.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
    
    func viewAccountData() {
        guard let account = getPopupAccount() else { return }
        
        showStatus("Retrieving account data, please wait...")
        
        account.getAllData() { data in
            let message = "Data has been loaded"
            DispatchQueue.main.async {
                self.showStatus(message)
                self.showData(data)
            }
        }
    }
    
    func showData(_ data: [String: String]) {
        print(data)
        print("Show data list")
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "accountDataController") as! AccountDataController
        controller.setData(data)
        windowData = NSWindow(contentViewController: controller)
        windowData.title = "Account Data"
        let app = NSApplication.shared()
        app.runModal(for: windowData)

        // Wait till modal is released
        
        if let pair = controller.selected {
            textDataKey.stringValue   = pair.key
            textDataValue.stringValue = pair.val
            textDataKey.becomeFirstResponder()
        }
        
    }
}

// END
