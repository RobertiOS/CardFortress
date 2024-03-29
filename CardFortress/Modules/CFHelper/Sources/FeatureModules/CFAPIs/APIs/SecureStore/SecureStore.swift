//
//  SecureStore.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/20/23.
//

import Foundation
import Combine

public protocol SecureStoreAPI {
    /// Removes all credit cards from secure store
    /// - Returns:returns an secure store result
    @discardableResult
    func removeAllCreditCards() async throws -> SecureStoreResult
    /// Adds a credit card to the secure store
    /// - Parameter card: the card to be added
    /// - Returns: returns an secure store result
    @discardableResult
    func addCreditCardToKeychain(_ creditCard: SecureStoreCreditCard) async throws -> SecureStoreResult
    /// Returns a credit card
    /// - Parameter identifier: The identifier of the credit card (UUID)
    /// - Returns: optional credit card
    func getCreditCardFromKeychain(identifier: UUID) async throws -> SecureStoreCreditCard?
    /// Returns all credit cards from secure store
    /// - Returns: Array of credit cards
    func getAllCreditCardsFromKeychain() async throws -> [SecureStoreCreditCard]
    /// Returns the Favorite credit card from the data source
    /// - Returns: An optional credit
    func getFavoriteCreditCard() async -> SecureStoreCreditCard?
}

extension SecureStoreAPI {
    func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}

public actor SecureStore: SecureStoreAPI {
    private var sSQueryable: SecureStoreQueryable
    
    public init(
        sSQueryable: SecureStoreQueryable = CreditCardSSQueryable(service: "CreditCards")
    ) {
        self.sSQueryable = sSQueryable
    }
    
    @discardableResult
    public func removeAllCreditCards() async throws -> SecureStoreResult {
        try await withCheckedThrowingContinuation { continuation in
            let query = sSQueryable.query
            let status = SecItemDelete(query as CFDictionary)
            switch status {
            case errSecSuccess:
                continuation.resume(returning: .success)
            case errSecItemNotFound:
                continuation.resume(returning: .failure(.itemNotFound))
            default:
                let secureStoreError = error(from: status)
                continuation.resume(throwing: secureStoreError)
            }
        }
    }

    public func addCreditCardToKeychain(_ creditCard: SecureStoreCreditCard) async throws -> SecureStoreResult {
        
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecReturnData)] = false
        keychainQuery[String(kSecAttrAccount)] = creditCard.identifier.uuidString
        
        return try await withCheckedThrowingContinuation { continuation in
            var status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
            let creditCardData = try? getCreditCardDataFrom(creditCard)
            switch status {
            case errSecSuccess:
                var attributesToUpdate: [String: Any] = [:]
                attributesToUpdate[String(kSecValueData)] = creditCardData
                status = SecItemUpdate(keychainQuery as CFDictionary,
                                       attributesToUpdate as CFDictionary)
                continuation.resume(returning: .editSuccess)
            case errSecItemNotFound:
                keychainQuery[String(kSecValueData)] = creditCardData
                status = SecItemAdd(keychainQuery as CFDictionary, nil)
                continuation.resume(returning: .addSuccess)
            default:
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    public func getCreditCardFromKeychain(identifier: UUID) async throws -> SecureStoreCreditCard? {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecAttrAccount)] = identifier.uuidString
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        return try await withCheckedThrowingContinuation { continuation in
            var item: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
            
            if status == errSecSuccess, let data = item as? Data {
                do {
                    let creditCard = try JSONDecoder().decode(SecureStoreCreditCard.self, from: data)
                    continuation.resume(returning: creditCard)
                } catch {
                    continuation.resume(throwing: SecureStoreError.unhandledError(message: "Error while decoding credit cards"))
                }
                
            } else {
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    public func getAllCreditCardsFromKeychain() async throws -> [SecureStoreCreditCard] {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitAll
        return try await withCheckedThrowingContinuation { continuation in
            var items: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
            switch status {
            case errSecSuccess:
                if let items = items as? [Data] {
                    let secureStoreCD = items.compactMap {
                        do {
                            return try JSONDecoder().decode(SecureStoreCreditCard.self, from: $0)
                        } catch {
                            continuation.resume(throwing: SecureStoreError.unhandledError(message: "Error while decoding credit cards"))
                            return nil
                        }
                    }
                    continuation.resume(returning: secureStoreCD)
                }
            case errSecItemNotFound:
                continuation.resume(returning: [])
            default:
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    public func getFavoriteCreditCard() async -> SecureStoreCreditCard? {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecMatchLimit)] = 1
        
        return await withCheckedContinuation { continuation in
            var items: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
            switch status {
            case errSecSuccess:
                if let item = items as? Data,
                   let card = try? JSONDecoder().decode(SecureStoreCreditCard.self, from: item) {
                    continuation.resume(returning: card)
                }
            case errSecItemNotFound:
                continuation.resume(returning: nil)
            default:
                continuation.resume(returning: nil)
            }
        }
    }
    
    //MARK: Helpers
    
    private func getCreditCardDataFrom(_ secureStoreCreditCard: SecureStoreCreditCard) throws -> Data {
        let payload: [String: Any] = [
            CreditCardProperty.identifier.rawValue : secureStoreCreditCard.identifier.uuidString,
            CreditCardProperty.number.rawValue : secureStoreCreditCard.number,
            CreditCardProperty.cvv.rawValue : secureStoreCreditCard.cvv,
            CreditCardProperty.date.rawValue : secureStoreCreditCard.date,
            CreditCardProperty.cardName.rawValue : secureStoreCreditCard.cardName,
            CreditCardProperty.cardHolderName.rawValue : secureStoreCreditCard.cardHolderName
        ]
        return try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
    }
}
