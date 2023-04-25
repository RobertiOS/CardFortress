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
        let items = ["item1", "item2", "item3"]
        
        let expectation = self.expectation(description: "Items should be emited")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.updateItems(items)
        
        waitForExpectations(timeout: 0.3)
        let updatedSnapshot = sut.testHooks.snapshot
        XCTAssert(updatedSnapshot.numberOfItems == items.count, "\(updatedSnapshot.numberOfItems) is not equat to 3")
    }
    
}

class MockViewModel: ListViewModelProtocol {
    func updateItems(_ items: [String]) {
        itemsSubject.send(items)
    }

    let itemsSubject = PassthroughSubject<[String], Never>()

    var itemsPublisher: AnyPublisher<[String], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchItems() {
        // do nothing
    }
}
