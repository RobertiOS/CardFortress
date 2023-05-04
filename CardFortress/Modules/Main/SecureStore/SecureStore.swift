//
//  SecureStore.swift
//  CardFortress
//
//  Created by Roberto Corrales on 30/04/23.
//

import Foundation
import Security
import Combine

enum SecureStoreResult {
    case success
    case failure(Error)
}


protocol SecureStoreProtocol {
    func addCreditCardToKeychain(_ card: CreditCard) -> Future<SecureStoreResult, Error>
    func getCreditCardFromKeychain(identifier: UUID) throws -> CreditCard?
    func getAllCreditCardsFromKeychain() -> Future<[CreditCard], Error>
    func removeAllCreditCards() -> Future<SecureStoreResult, Error>
}


final class SecureStore: SecureStoreProtocol  {
   
    private let sSQueryable: SecureStoreQueryable

    init(sSQueryable: SecureStoreQueryable) {
        self.sSQueryable = sSQueryable
    }

    func removeAllCreditCards() -> Future<SecureStoreResult, Error> {
        let query = sSQueryable.query
        return Future { promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                let status = SecItemDelete(query as CFDictionary)
                if status == errSecSuccess || status == errSecItemNotFound {
                    promise(.success(.success))
                } else {
                    promise(.failure(self.error(from: status)))
                }
            }
        }
    }
    // MARK: Properties
    
    func getAllCreditCardsFromKeychain() -> Future<[CreditCard], Error> {

        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitAll
        return Future<[CreditCard], Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                var items: CFTypeRef?
                let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
                
                DispatchQueue.main.async {
                    switch status {
                    case errSecSuccess:
                        if let items = items as? [Data] {
                            let jsonDecoder = JSONDecoder()
                            let cards = items.compactMap {
                                do {
                                    let card = try jsonDecoder.decode(CreditCard.self, from: $0)
                                    return card
                                } catch {
                                    promise(.failure(SecureStoreError.jsonDecodingError(message: error.localizedDescription)))
                                    return nil
                                }
                            }
                            promise(.success(cards))
                            
                        }
                    case errSecItemNotFound:
                        promise(.success([]))
                        
                    default:
                        promise(.failure(self.error(from: status)))
                    }
                }
            }
        }
    }

    func getCreditCardFromKeychain(identifier: UUID) throws -> CreditCard? {
        
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecAttrAccount)] = identifier.uuidString
        keychainQuery[String(kSecMatchLimit)] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return try JSONDecoder().decode(CreditCard.self, from: data)
        } else {
            print("No se pudo leer la tarjeta de crédito del Keychain. Código de error: \(status)")
            return nil
        }

    }
    
    func addCreditCardToKeychain(_ card: CreditCard) -> Future<SecureStoreResult, Error> {
        let cardData : [String : Any] = [
            "identifier": card.identifier.uuidString,
            "number": card.number,
            "cvv": card.cvv,
            "date": card.date,
            "cardName": card.cardName,
            "cardHolderName": card.cardHolderName
        ]
        
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecReturnData)] = false
        keychainQuery[String(kSecAttrAccount)] = card.identifier.uuidString
        
        return Future<SecureStoreResult, Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: cardData, options: .prettyPrinted)
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
                        DispatchQueue.main.async {
                            promise(.failure(self.error(from: status)))
                        }
                    }
                    DispatchQueue.main.async {
                        status == errSecSuccess ?
                        promise(.success(.success)) :
                        promise(.failure(self.error(from: status)))
                    }
                    
                    
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
    
    private func error(from status: OSStatus) -> SecureStoreError {
      let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
      return SecureStoreError.unhandledError(message: message)
    }
}
