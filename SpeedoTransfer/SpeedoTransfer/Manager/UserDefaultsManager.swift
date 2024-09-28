//
//  UserDefaultsManager.swift
//  Registration
//
//  Created by Merna Islam on 29/08/2024.
//

import Foundation

class UserDefaultsManager {
    
    // MARK: - Singleton
    static private let sharedInstance = UserDefaultsManager()
    
    static func shared() -> UserDefaultsManager {
        return UserDefaultsManager.sharedInstance
    }
    
    // MARK: - Computed Proprties
    private let def = UserDefaults.standard
    var isFirstOpen: Bool {
        set {
            def.setValue(newValue, forKey: "isFirstOpen")
        } get {
            if def.object(forKey: "isFirstOpen") == nil {
                return true
            }
            return false
        }
    }
    
    var isLoggedIn: Bool {
        set {
            def.setValue(newValue, forKey: "isLoggedIn")
        } get {
            if def.object(forKey: "isLoggedIn") == nil {
                return false
            }
            
            if def.bool(forKey: "isLoggedIn") {
                return true
            }
            return false
        }
    }
    
}
