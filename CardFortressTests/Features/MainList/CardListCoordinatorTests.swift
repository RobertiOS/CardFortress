//
//  CardListCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/9/23.
//

import XCTest
import CFDomain
@testable import CardFortress

final class CardListCoordinatorTests: XCTestCase {
    
    var coordinator: CardListCoordinator!
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        
        let window = UIWindow()
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        coordinator = CardListCoordinator(
            viewControllerFactory: CardListViewControllerFactoryMock(),
            navigationController: navigationController,
            container: .mockContainer
        )
    }
    
    override func tearDown() {
        super.tearDown()
        coordinator = nil
        navigationController = nil
    }

    func test_start() {
        // When
        coordinator.start()
        // Then
        XCTAssertTrue(navigationController.topViewController is CardListViewController)
    }
    
    func test_startEditCreditCardCoordinator() {
        //given
        let creditCard = DomainCreditCard(
            identifier: UUID(),
            number: "123",
            cvv: 123,
            date: "123",
            cardName: "Visa",
            cardHolderName: "Juan Perez",
            notes: "notes",
            isFavorite: false
        )
        // When
        coordinator.editCreditCard(creditCard: creditCard)
        // Then
        XCTAssertTrue(navigationController.viewControllers[0] is AddCreditCardViewController)
    }
    
    @MainActor
    func test_deleteCreditCards() async {
        // When
        let result = await coordinator.deleteCreditCard(id: UUID())
        // Then
        XCTAssertEqual(result, .success)
    }
    
    func test_signOut() {
        // When
        coordinator.signOut()
    }

}
