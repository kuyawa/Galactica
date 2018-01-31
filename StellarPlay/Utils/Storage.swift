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
// ie. account-1{G123456:Test:Test Account}
//     account-2{G987654:Live:Cash Account}
//     account-3{G666555:Live:Secret Vault}

class Storage {
    
    //var app = NSApp.delegate as! AppDelegate

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
        if numAccounts < 1 { /* Use test account */
            accounts.append(AccountData(key: app.testAccount, sec:"", net: "Test", name: "Test Account"))
        } else {
            var num = 1
            while let account: String = defaults.string(forKey: "account-"+num.description) {
                let parts = account.components(separatedBy: ":")
                if(parts.count==3){
                    accounts.append(AccountData(key: parts[0], sec: "", net: parts[1], name: parts[2]))
                }
                num += 1
            }
        }
    }
    
    func saveAccounts() {
        let defaults = UserDefaults.standard
        for (index, item) in accounts.enumerated() {
            let value = item.key+":"+item.net+":"+item.name
            defaults.set(value, forKey: "account+"+index.description)
        }
        defaults.set(accounts.count, forKey: "num-accounts")
        defaults.synchronize()
    }
}
