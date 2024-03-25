//
//  SecureStoreQueryable.swift
//  CardFortress
//
//  Created by Roberto Corrales on 1/05/23.
//

import Foundation

public protocol SecureStoreQueryable: AnyObject {
    var query: [String: Any] { get }
}

public final class CreditCardSSQueryable {
    
    public struct Constants {
        public static let accessGroup = "group.robertios.CardFortress.sharedItems"
        public static let service = "com.robertios.CardFortress.creditCards"
    }
    
    let service: String
    let accessGroup: String?
    
    public init(
        service: String = Constants.service,
        accessGroup: String = Constants.accessGroup
    ) {
      self.service = service
      self.accessGroup = accessGroup
    }
}

extension CreditCardSSQueryable: SecureStoreQueryable {
    public var query: [String : Any] {
        var query: [String : Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrService)] = service
        query[String(kSecAttrAccessGroup)] = accessGroup
        return query
    }
}
