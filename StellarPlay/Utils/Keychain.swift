//
//  Keychain.swift
//  StellarPlay
//
//  Created by Laptop on 1/29/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import Security

class Keychain {
    static let prefix = "stellarplay.keychain.address."

    class func save(_ key: String, _ data: Data) -> Bool {
        let tag = (prefix + key).data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass       as String : kSecClassGenericPassword,
            kSecAttrAccount as String : tag,
            kSecValueData   as String : data ]
        
        SecItemDelete(query as CFDictionary)
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    class func load(_ key: String) -> Data? {
        let tag = (prefix + key).data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass       as String : kSecClassGenericPassword,
            kSecAttrAccount as String : tag,
            kSecReturnData  as String : kCFBooleanTrue,
            kSecMatchLimit  as String : kSecMatchLimitOne ]
        
        var dataTypeRef: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return (dataTypeRef as! Data)
        }

        return nil
    }

    class func delete(_ key: String) -> Bool {
        let tag = (prefix + key).data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : tag
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }

    class func clear() -> Bool {
        let query = [kSecClass as String: kSecClassGenericPassword]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }

}
