//
//  ListViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 29/04/23.
//

import XCTest
import Combine
import Domain
@testable import CardFortress

final class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModelProtocol!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = ListViewModel(
            getCreditCardsUseCase: GetCreditCardsUseCaseMock(),
            removeCreditCardUseCase: RemoveCreditCardUseCaseMock()
        )
        subscriptions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        subscriptions = nil
    }
    
    func testViewModelFetchCards() {
        
        //given
        var creditCards = [DomainCreditCard]()

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
}
