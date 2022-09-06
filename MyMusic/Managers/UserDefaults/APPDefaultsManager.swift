//
//  APPDefaultsManager.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 27.08.22.
//

import Foundation

class APPDefaultsManager {
    
    private static let defaults = UserDefaults.standard
    
    //MARK: - Setters
    static func setObject(value: AnyObject, key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setString(value: String, key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setDate(value: Date, key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    //MARK: - Getters
    static func getObject(key: String) -> AnyObject? {
        return defaults.object(forKey: key) as AnyObject?
    }
    
    static func getString(key: String) -> String? {
        return defaults.string(forKey: key) as String?
    }
    
    static func getDate(key: String) -> Date? {
        return defaults.object(forKey: key) as? Date
    }
    
    //MARK: - Remover
    static func removeObject(key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}
