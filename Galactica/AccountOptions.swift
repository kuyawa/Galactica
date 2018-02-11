//
//  AccountOptions.swift
//  Galactica
//
//  Created by Laptop on 2/10/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import StellarSDK

extension ViewController {
    
    func getPopupAccount() -> StellarSDK.Account? {
        let selAcct = popupSetAccount.selectedTag()
        
        guard selAcct > -1 else { showWarning("Select your sending account"); return nil }
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

        buttonSetOptions.isEnabled = false
        showStatus("Setting authorization, please wait...")
        
        let flags = StellarSDK.AccountAuthorizationFlags(
                        required : checkAuthRequired.state.on,
                        revocable: checkAuthRevocable.state.on,
                        immutable: checkAuthImmutable.state.on)
        
        account.setAuthorization(flags) { response in
            var message = "Authorization has been set"
            
            if response.error {
                print("\nResponse", response.raw)
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
        let destin = textSetInflation.stringValue
        guard !destin.isEmpty else { showWarning("Inflation destination can not be empty"); return }
        
        buttonSetInflation.isEnabled = false
        showStatus("Setting inflation destination, please wait...")
        
        account.setInflation(address: destin, memo: "Inflation") { response in
            var message = "Inflation destination has been set"
            
            if response.error {
                print("\nResponse", response.raw)
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
            var message = "Asset has been trusted!"
            
            if response.error {
                print("\nResponse", response.raw)
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
        let limit  = Int64(textChangeTrustLimit.integerValue)
        guard !symbol.isEmpty else { showWarning("Asset can not be empty"); return }
        guard let asset = Asset(assetCode: symbol, issuer: issuer) else { showWarning("Invalid asset"); return }
        
        buttonChangeTrust.isEnabled = false
        showStatus("Changing asset trust, please wait...")
        
        account.changeTrust(asset: asset, limit: limit) { response in
            var message = "Asset trust has been changed!"
            
            if response.error {
                print("\nResponse", response.raw)
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
            var message = "Home domain has been set"
            
            if response.error {
                print("\nResponse", response.raw)
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
            var message = "Data value has been set"
            
            if response.error {
                print("\nResponse", response.raw)
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
            var message = "Accounts have been merged!"
            
            if response.error {
                print("\nResponse", response.raw)
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
            var message = "Account has been funded!"
            
            if response.error {
                print("\nResponse", response.raw)
                message = "Error funding account, try again later"
            }
            
            DispatchQueue.main.async {
                self.buttonFund.isEnabled = true
                self.showStatus(message, response.error)
            }
        }
    }
}

// END
