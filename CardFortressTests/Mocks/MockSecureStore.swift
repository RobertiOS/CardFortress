//
//  MockSecureStore.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/6/23.
//

@testable import CardFortress
import Combine
import Foundation

final class SecureStoreMock: SecureStoreProtocol {
    func removeAllCreditCards() -> Future<CardFortress.SecureStoreResult, Error> {
        Future { promise in
            promise(.success(.success))
        }
    }
    
    
    func addCreditCardToKeychain(_ card: CardFortress.CreditCard) -> Future<CardFortress.SecureStoreResult, Error> {
        Future { promise in
            promise(.success(.success))
        }
    }
    
    
    func getCreditCardFromKeychain(identifier: UUID) throws -> CardFortress.CreditCard? {
        return nil
    }
    
    func getAllCreditCardsFromKeychain() -> Future<[CardFortress.CreditCard], Error> {
        Future { promise in
            promise(.success([CreditCard(identifier: UUID(), number: 123, cvv: 123, date: "12/12/12", cardName: "Visa", cardHolderName: "Juan Perez")]))
        }
    }
}
