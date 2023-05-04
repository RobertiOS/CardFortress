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
        
        cardListService.getCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { cards in
                expectation.fulfill()
                creditCards = cards
            }.store(in: &subscritions)
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 1)
    }
    
    func testDeleteCreditCards() {
        //given
        let expectation = self.expectation(description: "delete cards")
        
        cardListService.deleteAllCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { status in
                if case .success = status {
                    expectation.fulfill()
                }
            }.store(in: &subscritions)
        waitForExpectations(timeout: 1)
    }
    
}

class SecureStoreMock: SecureStoreProtocol {
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


