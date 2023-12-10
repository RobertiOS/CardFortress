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

    var viewController: CardListViewController!
    var viewModel: ListViewModelProtocol!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = MockListViewModel(cardListService: MockListService())
        viewController = CardListViewController(viewModel: viewModel)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testTitle_isCorrect() {
        //given
        let title = "Card Fortress"
        XCTAssertEqual(title, viewController.navigationItem.title)
    }
    
    func testdeleteCardAlertIsPresented() throws {
        //given
        XCTAssertNil(viewController.presentedViewController)
        //when
        viewController.testHooks.deleteAllCreditCards()
        XCTAssertNotNil(viewController.presentedViewController)
        
        let alertController = try XCTUnwrap(viewController.presentedViewController as? UIAlertController)
        //then
        XCTAssertEqual(alertController.textFields?.count, 0)
        XCTAssertEqual(alertController.title, "Delete all credit cards")
        XCTAssertEqual(alertController.actions.count, 2)

    }
    
    func testUpdate_CollectionViewDataSource() {
        // Given
        let viewModel = MockListViewModel(cardListService: MockListService())

        let cards = [
            CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Visa", cardHolderName: "Juan Perez"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Visa", cardHolderName: "Juan Perez")
        ]
        
        let viewController = CardListViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(viewController.testHooks.snapshot?.numberOfItems, 0)

        // When
        
        let expectation = self.expectation(description: "Items should be emited")
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //update credit cards
        viewModel.cards = cards
        waitForExpectations(timeout: .defaultWait)
        // Then
        XCTAssertEqual(viewController.testHooks.snapshot?.numberOfItems, 3)
        
    }
}
