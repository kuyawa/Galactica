//
//  Storage.swift
//  StellarPlay
//
//  Created by Laptop on 1/30/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa


// Primitive storage for a few accounts in UserDefaults
// No need for full fledged database
// Accounts are stored as account-1..9 { publicKey : network : name }
// ie. account-1 {G123456:Test:Test Account}
//     account-2 {G987654:Live:Cash Account}
//     account-3 {G666555:Live:Secret Vault}

class Storage {
    
    struct AccountData {
        var key  = ""
        var sec  = ""
        var net  = ""
        var name = ""
    }
    
    var accounts: [AccountData] = []
    
    func loadAccounts(_ app: AppDelegate) {
        let defaults = UserDefaults.standard
        let numAccounts: Int = defaults.integer(forKey: "num-accounts")
        accounts.removeAll()
        
        if numAccounts < 1 { /* Use test account */
            accounts.append(AccountData(key: app.testAccount, sec:"", net: "Test", name: "Test Account"))
        } else {
            var num = 0
            while let account: String = defaults.string(forKey: "account-"+num.str) {
                let parts = account.components(separatedBy: ":")
                if(parts.count==3){
                    accounts.append(AccountData(key: parts[0], sec: "", net: parts[1], name: parts[2]))
                }
                num += 1
            }
        }
    }
    
    func saveAccounts() {
        clearAccounts()
        let defaults = UserDefaults.standard
        for (index, item) in accounts.enumerated() {
            let value = item.key+":"+item.net+":"+item.name
            defaults.set(value, forKey: "account-"+index.str)
        }
        
        defaults.set(accounts.count, forKey: "num-accounts")
        defaults.synchronize()
    }
    
    func clearAccounts() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func removeAccount(_ key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
    func printAccounts() {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
    }
}
