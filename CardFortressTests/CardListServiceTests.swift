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
        cardListService = CardListService()
        subscritions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        cardListService = nil
        subscritions = nil
    }
    
    func testFetchItems() {
        //given
        var creditCards: [String] = []
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
        XCTAssertEqual(creditCards.count, 10)
    }
    
}


