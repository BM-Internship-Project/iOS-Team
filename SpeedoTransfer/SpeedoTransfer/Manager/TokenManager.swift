//
//  TokenManager.swift
//  Registration
//
//  Created by Merna Islam on 11/09/2024.
//

class TokenManager {
    
    // MARK: - Singleton
    static private let sharedInstance = TokenManager()
    
    static func shared() -> TokenManager {
        return TokenManager.sharedInstance
    }
    
    private var token: String?
    
    func setToken(_ newToken: String) {
        token = newToken
        KeychainManager.saveTokenToKeychain(token: newToken)
    }
    
    func getToken() -> String? {
        if token == nil {
            token = KeychainManager.getTokenFromKeychain()
        }
        return token
    }
    
    func clearToken() {
        token = nil
        KeychainManager.deleteTokenFromKeychain()
    }
}

