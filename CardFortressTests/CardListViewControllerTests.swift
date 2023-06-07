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
    
    func testaddCardAlertIsPresented() throws {
        //given
        XCTAssertNil(viewController.presentedViewController)
        
        //when
        viewController.testHooks.presentAddCreditCardAlertController()
        let alertController = try XCTUnwrap(viewController.presentedViewController as? UIAlertController)

        //then
        XCTAssertEqual(alertController.textFields?.count, 5)
        XCTAssertEqual(alertController.title, "Add Credit Card")
        XCTAssertEqual(alertController.actions.count, 2)
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
        let snapshot = viewController.testHooks.snapshot
        XCTAssert(snapshot.numberOfItems == 0, "Initial snapshot should have 0 items")
        let cards = [
            CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Visa", cardHolderName: "Juan Perez"),
            CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Visa", cardHolderName: "Juan Perez")
        ]
        
        cards.forEach {
            viewModel.addCreditCard($0)
        }
        
        let expectation = self.expectation(description: "Items should be emited")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { _ in
                expectation.fulfill()
            })
            
            .store(in: &cancellables)
        viewModel.fetchCreditCards()
        
        waitForExpectations(timeout: .defaultWait)
        let updatedSnapshot = viewController.testHooks.snapshot
        XCTAssertEqual(updatedSnapshot.numberOfItems, cards.count, "\(updatedSnapshot.numberOfItems) is not equat to 3")
    }
}

extension TimeInterval {
    static var defaultWait: TimeInterval {
        1.5
    }
}
