//
//  Cache.swift
//  Galactica
//
//  Created by Laptop on 2/9/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import StellarSDK

class AppCache {
    var accounts: [String: Storage.AccountData] = [:]
    var assets: [String: [AssetData]] = [:]
    
    // Accounts
    // app.cache.accounts[pubkey] = info
    // let info = app.cache.accounts[pubkey]
    
    // Assets
    // app.cache.assets[pubkey] = assets
    // let assets = app.cache.assets[pubkey]
    
    //func setAccount(publicKey: String, info: Storage.AccountData) {
    //    self.accounts[publicKey] = info
    //}
    
    //func setAssets(publicKey: String, assets: [AssetData]) {
    //    self.assets[publicKey] = assets
    //}
}
