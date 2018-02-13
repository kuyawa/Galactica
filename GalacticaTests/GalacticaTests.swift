//
//  GalacticaTests.swift
//  GalacticaTests
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

// Copy StellarSDK and CryptoSwift frameworks to ../DerivedData/galactica-xxx/build/products/debug/

import XCTest
@testable import StellarSDK


let testAddress = "GAMMLP3BRHWAIRNNSAKD7UXWFITNI3YODZV4CFQ7FSILIL7E6SKQWTTX"
let testSecret  = "SDS54DFAILKMUWZOVIPN4Q4SSE33T4FEJP2MLOBEBNGFKINO46ZXXZDN"
let testDestin  = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"

class GalacticaTests: XCTestCase {
    
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
        
        print("Public key", keyPair.stellarPublicKey)  // 35 bytes 56 chars starting with G
        print("Secret key", keyPair.stellarSecretKey)  // 35 bytes 56 chars starting with S
        print("\nPublic bytes", keyPair.publicKey)  // 32 bytes
        print("\nSecret bytes", keyPair.secretKey)  // 32 bytes
        
        let keyData = keyPair.stellarPublicKey.base32DecodedData!.subdata(in: 1..<33).bytes
        
        XCTAssertEqual(keyData, keyPair.publicKey, "Public keys match")
    }
    
    func testKeychain() {
        print("\n---- \(#function)\n")
        
        let key1 = testAddress
        let sec1 = "S12345..."
        let ok1 = Keychain.save(key1, sec1)
        print("OK1", ok1)
        
        let key2 = testDestin
        let sec2 = "S98765..."
        let ok2 = Keychain.save(key2, sec2)
        print("OK2", ok2)
        
        let get1 = Keychain.load(key1)
        print("Sec1", get1)
        
        let get2 = Keychain.load(key2)
        print("Sec2", get2)
        
        Keychain.delete(key1)
        Keychain.delete(key2)
        
        //XCTAssertEqual(sec1, get1, "Error accessing keychain")
        //XCTAssertEqual(sec2, get2, "Error accessing keychain")
    }

    func testAccountInfo() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT INFO")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getInfo { info in
            print()
            print("RAW:", info.raw ?? "?")
            print("----")
            print("Id"           , info.id            ?? "?")
            print("info id"      , info.accountId     ?? "?")
            print("Paging token" , info.pagingToken   ?? "?")
            print("Sequence"     , info.sequence      ?? "?")
            print("SubentryCount", info.subentryCount)
            print("Thresholds"   , info.thresholds    ?? "?")
            print("Flags"        , info.flags         ?? "?")
            print("Balances"     , info.balances)
            print("Signers"      , info.signers)
            print("Data"         , info.data)
            print("Links"        , info.links         ?? "?")
            
            XCTAssertNil(info.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Timeout Error: \(error.localizedDescription)") }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
