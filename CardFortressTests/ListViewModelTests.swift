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
        var creditCards = [CreditCard]()
        //when
        
        let expectation = self.expectation(description: "fetch cards")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                creditCards = cards
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        

        viewModel.fetchItems()

        waitForExpectations(timeout: 0.3)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 3)
    }
    
    func testViewModelUpdateCards() {
        
        //given
        var creditCards = [CreditCard]()
        //when
        
        let expectation = self.expectation(description: "update cards")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                creditCards = cards
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.updateItems([
            CreditCard(number: 123, cvv: 123, date: "123", name: "Visa"),
        ])

        waitForExpectations(timeout: 0.3)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 1)
        XCTAssertEqual(creditCards.first?.name, "Visa")
    }
}

class MockListService: CardListServiceProtocol {
    func getCards() -> Future<[CreditCard], Error> {
        let cards = [
            CreditCard(number: 123, cvv: 123, date: "123", name: "Visa"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", name: "MasterCard"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", name: "Banpro")
        ]
        return Future { promise in
                promise(.success(cards))
        }
    }
    
    func saveCart() {
        //No op
    }
}
