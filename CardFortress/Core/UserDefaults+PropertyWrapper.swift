//
//  UserDefaults+PropertyWrapper.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/21/23.
//

import Foundation

@propertyWrapper
struct Storage {
    private let key: String
    private let defaultValue: Bool
    
    init(key: String, defaultValue: Bool) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Bool {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.bool(forKey: key) 
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


struct UserDefaultsWrapper {
    
    @Storage(key: "isRememberMeEnabled", defaultValue: false)
    var isRememberMeEnabled: Bool
}
