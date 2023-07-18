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
        viewModel = ListViewModel(cardListService: MockListService())
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
        

        viewModel.fetchCreditCards()

        waitForExpectations(timeout: .defaultWait)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 3)
    }
    
    func testAddCreditCard() {
        
        //given
        let creditCard = CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez")
        
        //when
        let expectation = self.expectation(description: "add card")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                XCTAssertEqual(cards.count, 4)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.addCreditCard(creditCard)

        waitForExpectations(timeout: .defaultWait)

    }
    
    func testDeleteAllCards() {
        
        //given
        let expectation = self.expectation(description: "add card")

        //when
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                XCTAssertTrue(cards.isEmpty)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.deleteAllCards()

        waitForExpectations(timeout: .defaultWait)

    }
}
