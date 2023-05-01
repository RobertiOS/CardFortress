//
//  SecureStore.swift
//  CardFortress
//
//  Created by Roberto Corrales on 30/04/23.
//

import Foundation
import Security
import Combine


protocol SecureStoreProtocol {
    func saveCreditCardDataToKeychain(card: CreditCard) throws
    func getCreditCardFromKeychain(identifier: UUID) throws -> CreditCard?
    func getAllCreditCardsFromKeychain() -> Future<[CreditCard], Error>
    func removeAllCreditCards() -> Future<Bool, Error>
}


final class SecureStore: SecureStoreProtocol  {
   
    private let sSQueryable: SecureStoreQueryable
    
    init(sSQueryable: SecureStoreQueryable) {
        self.sSQueryable = sSQueryable
    }
    
    func removeAllCreditCards() -> Future<Bool, Error> {
        let query = sSQueryable.query
        return Future { promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                let status = SecItemDelete(query as CFDictionary)
                if status == errSecSuccess || status == errSecItemNotFound {
                    promise(.success(true))
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
        
        let future: Future<[CreditCard], Error> = Future { promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                var items: CFTypeRef?
                let status = SecItemCopyMatching(keychainQuery as CFDictionary, &items)
                
                if status == errSecSuccess, let items = items as? [Data] {
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
                } else {
                    promise(.failure(self.error(from: status)))
                }
            }
        }
        
        return future
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
    
    func saveCreditCardDataToKeychain(card: CreditCard) throws {
        let cardData : [String : Any] = [
            "identifier": card.identifier.uuidString,
            "number": card.number,
            "cvv": card.cvv,
            "date": card.date,
            "name": card.name
        ]
        
        var keychainQuery = sSQueryable.query
        keychainQuery[String(kSecReturnData)] = false
        keychainQuery[String(kSecAttrAccount)] = card.identifier.uuidString
        
        let data = try JSONSerialization.data(withJSONObject: cardData, options: .prettyPrinted)
        var status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
        switch status {
        // 4
        case errSecSuccess:
          var attributesToUpdate: [String: Any] = [:]
          attributesToUpdate[String(kSecValueData)] = data
          
          status = SecItemUpdate(keychainQuery as CFDictionary,
                                 attributesToUpdate as CFDictionary)
          if status != errSecSuccess {
              throw error(from: status)
          }
        // 5
        case errSecItemNotFound:
          keychainQuery[String(kSecValueData)] = data
          
          status = SecItemAdd(keychainQuery as CFDictionary, nil)
          if status != errSecSuccess {
            throw error(from: status)
          }
        default:
          throw error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> SecureStoreError {
      let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
      return SecureStoreError.unhandledError(message: message)
    }
}
