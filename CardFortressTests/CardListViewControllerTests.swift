//
//  CardListViewControllerTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 24/04/23.
//

import XCTest
import SwiftUI
import UIKit
import Combine
import CFSharedUI
import Domain
@testable import CardFortress


final class CardListViewControllerTests: XCTestCase {

    var viewController: CardListViewController!
    var viewModel: MockListViewModel!
    var cancellables = Set<AnyCancellable>()
    var delegate: MockDelegate!
    
    override func setUp() {
        super.setUp()
        viewModel = MockListViewModel()
        viewController = CardListViewController(viewModel: viewModel)
        delegate = MockDelegate()
        viewController.delegate = delegate
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        viewModel = nil
        delegate = nil
        super.tearDown()
    }
    
    func testTitle_isCorrect() {
        //given
        let title = "Card Fortress"
        XCTAssertEqual(title, viewController.navigationItem.title)
    }
    
    func testUpdate_CollectionViewDataSource() {
        // Given
        let viewModel = MockListViewModel()

        let cards = [
            DomainCreditCard(
                identifier: UUID(),
                number: "123",
                cvv: 123,
                date: "123",
                cardName: "Visa",
                cardHolderName: "Juan Perez",
                notes: "notes",
                isFavorite: false
            ),
            DomainCreditCard(
                identifier: UUID(),
                number: "123",
                cvv: 123,
                date: "123",
                cardName: "Visa",
                cardHolderName: "Juan Perez",
                notes: "notes",
                isFavorite: false
            ),
            DomainCreditCard(
                identifier: UUID(),
                number: "123",
                cvv: 123,
                date: "123",
                cardName: "Visa",
                cardHolderName: "Juan Perez",
                notes: "notes",
                isFavorite: false
            )
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
        let dataSource = viewController.testHooks.dataSource
        let collectionView = viewController.testHooks.collectionView
        let collectionViewCell = dataSource?.collectionView(
             collectionView,
             cellForItemAt: IndexPath(
                 item: 0,
                 section: 0
             )
         )
         
         XCTAssertNotNil(collectionViewCell)
    }
    
    func test_loadingState() {
        // Given
        let viewModel = MockListViewModel()
        
        let cards = [
            DomainCreditCard(
                identifier: UUID(),
                number: "123",
                cvv: 123,
                date: "123",
                cardName: "Visa",
                cardHolderName: "Juan Perez",
                notes: "notes",
                isFavorite: false
            )
        ]

        // When
        
        let viewController = CardListViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        
        // Then
        let exp = self.expectation(description: "wait for loading to emit")
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }.store(in: &cancellables)
        viewModel.isLoadingSubject.send(true)
        waitForExpectations(timeout: .defaultWait)
        
        
        //local variables to validate the behavior
        
        let dataSource = viewController.testHooks.dataSource
        let collectionView = viewController.testHooks.collectionView
        
        // validate that we have 3 place holder cells
        
        XCTAssertEqual(viewController.testHooks.snapshot?.numberOfItems, 3)
        
        let placeHolderCell = dataSource?.collectionView(
             collectionView,
             cellForItemAt: IndexPath(
                 item: 0,
                 section: 0
             )
         )
        XCTAssertEqual(dataSource?.snapshot().sectionIdentifiers.count, 1)
        XCTAssertTrue(placeHolderCell?.contentConfiguration is UIHostingConfiguration<CreditCardLoadingView, EmptyView>)
        
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
        
        let ItemCell = dataSource?.collectionView(
             collectionView,
             cellForItemAt: IndexPath(
                 item: 0,
                 section: 0
             )
         )
        XCTAssertEqual(viewController.testHooks.snapshot?.numberOfItems, 1)
        XCTAssertEqual(dataSource?.snapshot().sectionIdentifiers.count, 1)
        XCTAssertTrue(ItemCell?.contentConfiguration is UIHostingConfiguration<CreditCardView<EmptyView>, EmptyView>)
    }
    
    func testActionTitle() {
        // given
        let deleteAction = CardListViewController.Action.delete
        let editAction = CardListViewController.Action.edit
        
        // when
        let deleteTitle = deleteAction.title
        let editTitle = editAction.title
        
        // then
        XCTAssertEqual(deleteTitle, "Delete")
        XCTAssertEqual(editTitle, "Edit")
    }
    
    func testActionStyle() {
        // given
        let deleteAction = CardListViewController.Action.delete
        let editAction = CardListViewController.Action.edit
        
        // when
        let deleteStyle = deleteAction.style
        let editStyle = editAction.style
        
        // then
        XCTAssertEqual(deleteStyle, .destructive)
        XCTAssertEqual(editStyle, .normal)
    }
    
    func testDidSelectItem() {
        // given
        let collectionView = viewController.testHooks.collectionView
        
        let expectation = self.expectation(description: "Wait for cards to be emitted")
        viewModel
            .itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            
        } receiveValue: { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.cards = [
            DomainCreditCard(
            identifier: UUID(),
            number: "123",
            cvv: 123,
            date: "123",
            cardName: "Visa",
            cardHolderName: "Juan Perez",
            notes: "notes",
            isFavorite: false
        )]
        waitForExpectations(timeout: .defaultWait)
        
        // when
        viewController.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        // then
        XCTAssertEqual(viewController.testHooks.snapshot?.numberOfItems, 1)
        XCTAssertTrue(delegate.editCreditCardCalled)
    }
}


extension CardListViewControllerTests {
    class MockDelegate: CardListViewControllerDelegate {
        var editCreditCardCalled = false
        var deleteCreditCardCalled = false
        var signOutCalled = false
        
        func signOut() {
            signOutCalled = true
        }
        
        func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult {
            deleteCreditCardCalled = true
            return .success
        }
        
        func editCreditCard(creditCard: DomainCreditCard) {
            editCreditCardCalled = true
        }
    }
}

extension UIAlertAction {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    func trigger() {
        guard let block = value(forKey: "handler") else {
            XCTFail("Should not be here")
            return
        }
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(self)
    }
}
