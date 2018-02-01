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
    
    @IBAction func onGenerate(_ sender: Any) {
        generateKeypair()
    }
    
    @IBAction func onFunding(_ sender: Any) {
        fundAccount()
    }
    
    func generateKeypair() {
        let keyPair = KeyPair.random()
        textAddress.stringValue = keyPair.publicKey.base32
        textSecret.stringValue  = keyPair.secretKey.base32
    }
    
    func testAccountInfo() {
        let keyPair   = KeyPair.random()
        let publicKey = keyPair.publicKey.base32
        let server    = StellarSDK.Horizon.test
        server.account(address: publicKey) { response in
            print("Raw:", response.text)
        }
    }
    
    func fundAccount() {
        let address = textAddress.stringValue
        let server  = StellarSDK.Horizon.test
        server.friendbot(address: address) { response in
            print("Raw:", response.text)
            let envelope = response.json["envelope_xdr"] as! String
            print("Env:", envelope)
            let data = Data(base64Encoded: envelope)!
            print("Data:", data.bytes)
            let info = String(xdr: data)
            print("Info:", info)
        }
    }

}
