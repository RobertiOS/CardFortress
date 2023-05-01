//
//  SecureStoreQueryable.swift
//  CardFortress
//
//  Created by Roberto Corrales on 1/05/23.
//

import Foundation

protocol SecureStoreQueryable: AnyObject {
    var query: [String: Any] { get }
}

final class CreditCardSSQueryable {
    
    let service: String
    let accessGroup: String?
    
    init(service: String, accessGroup: String? = nil) {
      self.service = service
      self.accessGroup = accessGroup
    }
}

extension CreditCardSSQueryable: SecureStoreQueryable {
    var query: [String : Any] {
        var query: [String : Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecReturnData)] = kCFBooleanTrue
        
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif
        
        return query
    }
}
