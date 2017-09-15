//
//  AppDefaults.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 14/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

class AppDefaults {
    
    static let shared = AppDefaults()
    
    private init() { }
    
    func getToken(for user: User) -> String? {
        let key = getUserDefaultsKey(for: user)
        return UserDefaults.standard.string(forKey: key)
    }
    
    func set(token: String, for user: User) {
        let key = getUserDefaultsKey(for: user)
        UserDefaults.standard.set(token, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func getUserDefaultsKey(for user: User) -> String {
        return String(format: "%@%@-%@", user.firstName!, user.lastName!, user.deviceId)
    }
    
    func save(user: User) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedUser, forKey: "currentUser")
    }
    
    func currentUser() -> User? {
        guard let encodedUser = UserDefaults.standard.data(forKey: "currentUser") else {
            return nil
        }
        guard let user = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? User else {
            return nil
        }
        return user
    }
}
