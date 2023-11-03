//
//  SecureStoreMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/23/23.
//

import Foundation
import CFAPIs

class SecureStoreMock: SecureStoreAPI {
    var addCreditCardToKeychainCalledCount = 0
    var getCreditCardsCalledCount = 0
    var getCreditCardCalledCount = 0
    var deleteCreditCardsCalledCount = 0
    
    var creditCards: [SecureStoreCreditCard] = [.make()]
    
    func removeAllCreditCards() async throws -> SecureStoreResult {
        deleteCreditCardsCalledCount += 1
        creditCards.removeAll()
        return .success
    }
    
    func addCreditCardToKeychain(_ creditCard: SecureStoreCreditCard) async throws -> SecureStoreResult {
        addCreditCardToKeychainCalledCount += 1
        creditCards.append(creditCard)
        return .success
    }
    
    func getCreditCardFromKeychain(identifier: UUID) async throws -> SecureStoreCreditCard? {
        getCreditCardCalledCount += 1
        return creditCards.first { $0.identifier == identifier }
    }
    
    func getAllCreditCardsFromKeychain() async throws -> [SecureStoreCreditCard] {
        getCreditCardsCalledCount += 1
        return creditCards
    }
    
    func getFavoriteCreditCard() async -> SecureStoreCreditCard? {
        .make()
    }
}
