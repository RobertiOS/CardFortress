//
//  SecureStorePOCMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/23/23.
//

import Foundation
@testable import CardFortress

class SecureStorePOCMock: SecureStoreProtocolPOC {
    
    var addCreditCardToKeychainCalledCount = 0
    var getCreditCardsCalledCount = 0
    var getCreditCardCalledCount = 0
    var deleteCreditCardsCalledCount = 0
    
    private var cardData : [String : Any] = [
        "identifier": UUID().uuidString,
        "number": Int.random(in: 1...40),
        "cvv": Int.random(in: 1...40),
        "date": "124",
        "cardName": "Card \(Int.random(in: 1...40))",
        "cardHolderName": "Juan Perez \(Int.random(in: 1...40))"
    ]

    func removeAllCreditCards() async throws -> CardFortress.SecureStoreResult {
        deleteCreditCardsCalledCount += 1
        return .success
    }
    
    func addCreditCardToKeychain(_ encodedCard: CardFortress.EncodedCard) async throws -> CardFortress.SecureStoreResult {
        addCreditCardToKeychainCalledCount += 1
        return .success
    }
    
    func getCreditCardFromKeychain(identifier: UUID) async throws -> Data? {
        
        var cardData : [String : Any] = [
            "identifier": identifier.uuidString,
            "number": Int.random(in: 1...40),
            "cvv": Int.random(in: 1...40),
            "date": "124",
            "cardName": "Card \(Int.random(in: 1...40))",
            "cardHolderName": "Juan Perez \(Int.random(in: 1...40))"
        ]
        getCreditCardCalledCount += 1
        return try createEncodedCreditCard(for: cardData).data
    }
    
    func getAllCreditCardsFromKeychain() async throws -> [Data] {
        getCreditCardsCalledCount += 1
        let data = try createEncodedCreditCard(for: cardData).data
        return [data]
    }
}
