//
//  Stuff.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import CryptoSwift

class Stuff {
    
    func testKeychain() {
        // TESTED!
        // In order to save public/secret keys first save public key in user defaults
        // Then on app load, get userdefaults first then get secret key from keychain
        // If no secret on keychain, account is read only
        // Userdefaults:
        //   accounts: n
        //   account-01: publicKey:name
        //   account-02: publicKey:name
        
        //let sig = CryptoSwift.sign???
        
        print("\n---- \(#function)\n")
        //let key = "G123456"
        //var ok  = false
        
        // Clear all
        //ok = Keychain.clear()
        //print("Clear", ok)
        
        // Remove
        //ok = Keychain.delete(key)
        //print("Delete", ok)
        
        // Set
        //let pair = KeyPair.random()
        //print("Secret", pair.secretKey) // [144, 237, 77, 115, 54, 60, 240, 46, 23, 214, 67, 159, 194, 168, 120, 173, 83, 202, 178, 49, 248, 125, 50, 205, 35, 173, 221, 224, 12, 42, 31, 22, 125, 86, 92]
        //let val  = pair.secretKey.base32       // SDWU24ZWHTYC4F6WIOP4FKDYVVJ4VMRR7B6TFTJDVXO6ADBKD4LH2VS4
        //ok = Keychain.save(key, val)
        //print("OK", ok, val, pair.secretKey)
        
        // Get
        //let xxx = [144, 237, 77, 115, 54, 60, 240, 46, 23, 214, 67, 159, 194, 168, 120, 173, 83, 202, 178, 49, 248, 125, 50, 205, 35, 173, 221, 224, 12, 42, 31, 22, 125, 86, 92]
        //print(xxx)
        //if let secretKey = Keychain.load(key) {
        //   print("OK", secretKey)
        //}
    }
    

}
