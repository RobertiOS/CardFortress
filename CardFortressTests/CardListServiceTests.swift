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
        cardListService = CardListService(secureStore: SecureStoreMock())
        subscritions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        cardListService = nil
        subscritions = nil
    }
    
    func testGetCreditCards() {
        //given
        var creditCards: [CreditCard] = []
        let expectation = self.expectation(description: "fetch cards")
        
        //when //then
        cardListService.getCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { cards in
                expectation.fulfill()
                creditCards = cards
            }.store(in: &subscritions)
        waitForExpectations(timeout: .defaultWait)
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 1)
    }
    
    func testDeleteCreditCards() {
        //given
        let expectation = self.expectation(description: "delete cards")
        
        //when //then
        cardListService.deleteAllCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { status in
                if case .success = status {
                    expectation.fulfill()
                }
            }.store(in: &subscritions)
        waitForExpectations(timeout: .defaultWait)
    }
    
    func testAddCreditCards() {
        //given
        let creditCard = CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez")
        let expectation = self.expectation(description: "Add credit card")
        
        cardListService.addCreditCardToSecureStore(creditCard)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { state in
                switch state {
                case .success:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }.store(in: &subscritions)
        waitForExpectations(timeout: .defaultWait)
    }
}


