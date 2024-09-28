//
//  KeychainManager.swift
//  Registration
//
//  Created by Merna Islam on 11/09/2024.
//

import Security
import Foundation

class KeychainManager {
    
    static func saveTokenToKeychain(token: String) {
        let tokenData = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken",
            kSecValueData as String: tokenData,
        ]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
        
    }
    
    static func getTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                return String(data: retrievedData, encoding: .utf8)
            }
        }
        
        return nil
    }
    
    
    static func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken"
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
}
