//
//  ListViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 29/04/23.
//

import XCTest
import Combine
@testable import CardFortress

final class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModelProtocol!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let service = MockListService()
        viewModel = ListViewModel(cardListService: service)
        subscriptions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        subscriptions = nil
    }
    
    func testViewModelFetchCards() {
        
        //given
        var creditCards = [String]()
        //when
        
        let expectation = self.expectation(description: "fetch cards")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { cards in
                creditCards = cards
                expectation.fulfill()
            }.store(in: &subscriptions)
        viewModel.fetchItems()

        waitForExpectations(timeout: 0.3)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 3)
        XCTAssertEqual(creditCards.first, "card1")
    }
    
    func testViewModelUpdateCards() {
        
        //given
        var creditCards = [String]()
        //when
        
        let expectation = self.expectation(description: "update cards")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { cards in
                creditCards = cards
                expectation.fulfill()
            }.store(in: &subscriptions)
        viewModel.updateItems(["card"])

        waitForExpectations(timeout: 0.3)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 1)
        XCTAssertEqual(creditCards.first, "card")
    }
}

class MockListService: CardListServiceProtocol {
    func getCards() -> Future<[String], Error> {
        Future { promise in
                promise(.success(["card1", "card2", "card3"]))
        }
    }
    
    func saveCart() {
        //No op
    }
}
