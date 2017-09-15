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
    
    func getToken() -> String? {
        guard let user = currentUser() else {return nil}
        return user.token
    }
    
    func set(token: String) {
        guard let user = currentUser() else {return}
        user.token = token
        save(user: user)
    }
    
    func save(user: User) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedUser, forKey: "currentUser")
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
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
