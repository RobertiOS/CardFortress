//
//  CardListViewControllerTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 24/04/23.
//

import XCTest
import UIKit
import Combine
@testable import CardFortress


final class CardListViewControllerTests: XCTestCase {

    var sut: CardListViewController!
    var viewModel: ListViewModelProtocol!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = MockViewModel()
        sut = CardListViewController(viewModel: viewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testTitle_isCorrect() {
        //given
        let title = "Card Fortress"
        XCTAssertEqual(title, sut.navigationItem.title)
    }
    
    
    func testUpdate_CollectionViewDataSource() {
        let snapshot = sut.testHooks.snapshot
        XCTAssert(snapshot.numberOfItems == 0, "Initial snapshot should have 0 items")
        let cards = [
            CreditCard(number: 123, cvv: 123, date: "123", name: "Visa"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", name: "MasterCard")
        ]
        
        let expectation = self.expectation(description: "Items should be emited")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { _ in
                expectation.fulfill()
            })
            
            .store(in: &cancellables)
        viewModel.updateItems(cards)
        
        waitForExpectations(timeout: 0.3)
        let updatedSnapshot = sut.testHooks.snapshot
        XCTAssert(updatedSnapshot.numberOfItems == cards.count, "\(updatedSnapshot.numberOfItems) is not equat to 3")
    }
    
}

class MockViewModel: ListViewModelProtocol {
    
    var cardListService: CardFortress.CardListServiceProtocol
    
    init(cardListService: CardFortress.CardListServiceProtocol = CardListService()) {
        self.cardListService = cardListService
    }
    
    func updateItems(_ items: [CreditCard]) {
        itemsSubject.send(items)
    }

    let itemsSubject = PassthroughSubject<[CreditCard], Error>()

    var itemsPublisher: AnyPublisher<[CreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchItems() {
        // do nothing
    }
}
