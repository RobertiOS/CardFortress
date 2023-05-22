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

enum CreditCardProperties: String, CaseIterable {
    case identifier
    case number
    case cvv
    case date
    case cardName
    case cardHolderName
    
    static var allCasesToString: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

struct EncodedCard {
    let identifier: UUID
    let data: Data
}

protocol SecureStoreProtocolPOC {
    /// Removes all credit cards from secure store
    /// - Returns:returns an secure store result
    @discardableResult
    func removeAllCreditCards() async throws -> SecureStoreResult
    /// Adds a credit card to the secure store
    /// - Parameter card: the card to be added
    /// - Returns: returns an secure store result
    func addCreditCardToKeychain(_ encodedCard: EncodedCard) async throws -> SecureStoreResult
    /// Returns a credit card
    /// - Parameter identifier: The identifier of the credit card (UUID)
    /// - Returns: optional credit card
    func getCreditCardFromKeychain(identifier: UUID) async throws -> Data?
    /// Returns all credit cards from secure store
    /// - Returns: Array of credit cards
    func getAllCreditCardsFromKeychain() async throws -> [Data]
    /// Creates an EncodedCard object that can be used for storing a credit card on keychain
    /// - Returns: An encoded credit card
    nonisolated func createEncodedCreditCard(for creditCardpayload: [String : Any]) throws -> EncodedCard
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
    func addCreditCardToKeychain(_ encodedCard: EncodedCard) async throws -> SecureStoreResult {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecReturnData)] = false
        keychainQuery[String(kSecAttrAccount)] = encodedCard.identifier.uuidString
        
        return try await withCheckedThrowingContinuation { continuation in
            var status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
            switch status {
            case errSecSuccess:
                var attributesToUpdate: [String: Any] = [:]
                attributesToUpdate[String(kSecValueData)] = encodedCard.data
                status = SecItemUpdate(keychainQuery as CFDictionary,
                                       attributesToUpdate as CFDictionary)
            case errSecItemNotFound:
                keychainQuery[String(kSecValueData)] = encodedCard.data
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
    
    func getCreditCardFromKeychain(identifier: UUID) async throws -> Data? {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecAttrAccount)] = identifier.uuidString
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        return try await withCheckedThrowingContinuation { continuation in
            var item: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)

            if status == errSecSuccess, let data = item as? Data {
                continuation.resume(returning: data)
            } else {
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    func getAllCreditCardsFromKeychain() async throws -> [Data] {
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitAll
        return try await withCheckedThrowingContinuation { continuation in
            var items: CFTypeRef?
            let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
            switch status {
            case errSecSuccess:
                if let items = items as? [Data] {
                    continuation.resume(returning: items)
                }
            case errSecItemNotFound:
                continuation.resume(returning: [])
            default:
                continuation.resume(throwing: error(from: status))
            }
        }
    }
    
    nonisolated func createEncodedCreditCard(for creditCardpayload: [String : Any]) throws -> EncodedCard {
        let requiredKeys = CreditCardProperties.allCasesToString
        let missingKeys = requiredKeys.filter { !creditCardpayload.keys.contains($0) }
        if !missingKeys.isEmpty {
            let missingKeysString = missingKeys.joined(separator: ", ")
            throw NSError(domain: "Missing keys", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing keys: \(missingKeysString)"])
        }
        guard let identifier = creditCardpayload["identifier"] as? String,
              let uuidItentifier = UUID(uuidString: identifier) else {
            throw NSError(domain: "Missing identifier", code: 0, userInfo: nil)
        }
        
        let data = try JSONSerialization.data(withJSONObject: creditCardpayload, options: .prettyPrinted)
        
        return EncodedCard(identifier: uuidItentifier, data: data)
    }
}
