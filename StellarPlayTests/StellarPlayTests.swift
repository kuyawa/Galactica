//
//  StellarPlayTests.swift
//  StellarPlayTests
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarPlay
@testable import StellarSDK
@testable import CryptoSwift

class StellarPlayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        print()
        super.tearDown()
    }
    
    func testKeypair() {
        print("\n---- \(#function)\n")
        let keyPair   = KeyPair.random()
        let publicKey = keyPair.publicKey
        print(publicKey.base32)
    }
    
    func testKeychain() {
        print("\n---- \(#function)\n")
        let pair = KeyPair.random()
        let tag  = "account-00"
        let val  = Data(pair.secretKey)
        let ok   = Keychain.save(tag, val)
        print("OK", ok)
        XCTAssertTrue(ok, "Error saving to the keychain")
    }
    
    func testHorizonTest() {
        print("\n---- \(#function)\n")
        //let keyPair   = KeyPair.random()
        //let publicKey = keyPair.publicKey.base32
        //let server    = StellarSDK.Horizon.test
        //server.account(address: publicKey) { response in
            //print("Raw:", response.raw)
        //}
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
