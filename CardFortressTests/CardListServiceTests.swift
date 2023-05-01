//
//  CardListServiceTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 29/04/23.
//

import Foundation
import XCTest
@testable import CardFortress
import Combine

class CardListServiceTests: XCTestCase {
    var cardListService: CardListServiceProtocol!
    var subscritions: Set<AnyCancellable>!
    override func setUp() {
        super.setUp()
        let secureStoreMock = SecureStoreMock()
        cardListService = CardListService(secureStore: secureStoreMock)
        subscritions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        cardListService = nil
        subscritions = nil
    }
    
    func testFetchCreditCards() {
        //given
        var creditCards: [CreditCard] = []
        let expectation = self.expectation(description: "fetch cards")
        
        cardListService.getCards()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { cards in
                expectation.fulfill()
                creditCards = cards
            }.store(in: &subscritions)
        waitForExpectations(timeout: 0.4)
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 1)
    }
    
}

class SecureStoreMock: SecureStoreProtocol {
    func saveCreditCardDataToKeychain(card: CardFortress.CreditCard) throws {
        
    }
    
    func getCreditCardFromKeychain(identifier: UUID) throws -> CardFortress.CreditCard? {
        return nil
    }
    
    func getAllCreditCardsFromKeychain() -> Future<[CardFortress.CreditCard], Error> {
        Future { promise in
            promise(.success([CreditCard(identifier: UUID(), number: 123, cvv: 123, date: "12/12/12", name: "Visa")]))
        }
    }
    
    func removeAllCreditCards() -> Future<Bool, Error> {
        Future { promise in
        }
    }
    
}


