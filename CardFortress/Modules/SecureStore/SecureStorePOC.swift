//
//  SecureStorePOC.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/20/23.
//

import Foundation
import Combine

enum SecureStoreStatus {
    case success
    case failure(Error)
}


protocol SecureStoreProtocolPOC {
    /// Removes all credit cards from secure store
    /// - Returns:returns an secure store result
    @discardableResult
    func removeAllCreditCards() async throws -> SecureStoreResult
    /// Adds a credit card to the secure store
    /// - Parameter card: the card to be added
    /// - Returns: returns an secure store result
    func addCreditCardToKeychain(_ card: CreditCard) async throws -> SecureStoreResult
    /// Returns a credit card
    /// - Parameter identifier: The identifier of the credit card (UUID)
    /// - Returns: optional credit card
    func getCreditCardFromKeychain(identifier: UUID) async throws -> CreditCard?
    /// Returns all credit cards from secure store
    /// - Returns: Array of credit cards
    func getAllCreditCardsFromKeychain() async throws -> [CreditCard]
}

extension SecureStoreProtocolPOC {
    func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}

actor SecureStorePOC: SecureStoreProtocolPOC {
    private var sSQueryable: SecureStoreQueryable
    
    init(sSQueryable: SecureStoreQueryable) {
        self.sSQueryable = sSQueryable
    }
    
    @discardableResult
    func removeAllCreditCards() async throws -> SecureStoreResult {
        try await withCheckedThrowingContinuation { continuation in
            let query = sSQueryable.query
            let status = SecItemDelete(query as CFDictionary)
            switch status {
            case errSecSuccess,
            errSecItemNotFound:
                continuation.resume(returning: .success)
            default:
                let secureStoreError = error(from: status)
                continuation.resume(throwing: secureStoreError)
            }
        }
    }
    /// priority user initiated
    func addCreditCardToKeychain(_ card: CreditCard) async throws -> SecureStoreResult {
        let cardData : [String : Any] = [
            "identifier": card.identifier.uuidString,
            "number": card.number,
            "cvv": card.cvv,
            "date": card.date,
            "cardName": card.cardName,
            "cardHolderName": card.cardHolderName
        ]
        let data = try JSONSerialization.data(withJSONObject: cardData, options: .prettyPrinted)
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecReturnData)] = false
        keychainQuery[String(kSecAttrAccount)] = card.identifier.uuidString
        
        return try await withCheckedThrowingContinuation { continuation in
            var status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
            switch status {
            case errSecSuccess:
                var attributesToUpdate: [String: Any] = [:]
                attributesToUpdate[String(kSecValueData)] = data
                status = SecItemUpdate(keychainQuery as CFDictionary,
                                       attributesToUpdate as CFDictionary)
            case errSecItemNotFound:
                keychainQuery[String(kSecValueData)] = data
                status = SecItemAdd(keychainQuery as CFDictionary, nil)
            default:
                continuation.resume(throwing: error(from: status))
            }
            //TODO: refactor
            if status == errSecSuccess {
                continuation.resume(returning: .success)
            } else {
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    func getCreditCardFromKeychain(identifier: UUID) async throws -> CreditCard? {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecAttrAccount)] = identifier.uuidString
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        
        return try await withCheckedThrowingContinuation { continuation in
            

            var item: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)

            if status == errSecSuccess, let data = item as? Data {
                do {
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: data)
                    continuation.resume(returning: creditCard)
                } catch {
                    continuation.resume(throwing: error)
                }
            } else {
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    func getAllCreditCardsFromKeychain() async throws -> [CreditCard] {
        
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitAll
        
        return try await withCheckedThrowingContinuation { continuation in
            var items: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
            
            switch status {
            case errSecSuccess:
                if let items = items as? [Data] {
                    let jsonDecoder = JSONDecoder()
                    let cards = items.compactMap {
                        do {
                            let card = try jsonDecoder.decode(CreditCard.self, from: $0)
                            return card
                        } catch {
                            continuation.resume(throwing: SecureStoreError.jsonDecodingError(message: error.localizedDescription))
                            return nil
                        }
                    }
                    continuation.resume(returning: cards)
                    
                }
            case errSecItemNotFound:
                continuation.resume(returning: [])
                
            default:
                continuation.resume(throwing: error(from: status))
            }
        }
    }
}
