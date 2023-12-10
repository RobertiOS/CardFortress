//
//  CardListCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/9/23.
//

import XCTest
@testable import CardFortress

final class CardListCoordinatorTests: XCTestCase {

    func test_start() {
        // Given
        let navigationController = UINavigationController()
        let coordinator = CardListCoordinator(
            viewControllerFactory: MockMainViewControllerFactory(),
            navigationController: navigationController,
            coordinatorFactory: MockCoordinatorFactory()
        )
        // When
        coordinator.start()
        // Then
        XCTAssertTrue(navigationController.viewControllers[0] is CardListViewControllerProtocol)
    }
    
    func test_startEditCreditCardCoordinator() {
        // Given
        let navigationController = UINavigationController()
        let coordinator = CardListCoordinator(
            viewControllerFactory: MockMainViewControllerFactory(),
            navigationController: navigationController,
            coordinatorFactory: MockCoordinatorFactory()
        )
        // When
        coordinator.editCreditCard(creditCard: .make())
        // Then
        XCTAssertNotNil(coordinator.testHooks.editCreditCardsCoordinator)
        XCTAssertTrue(navigationController.viewControllers[0] is AddCreditCardViewControllerProtocol)
        //when
        coordinator.testHooks.editCreditCardsCoordinator?.finish(())
        XCTAssertNil(coordinator.testHooks.editCreditCardsCoordinator)
    }
    
    @MainActor
    func test_deleteCreditCards() async {
        // Given
        let navigationController = UINavigationController()
        let coordinator = CardListCoordinator(
            viewControllerFactory: MockMainViewControllerFactory(),
            navigationController: navigationController,
            coordinatorFactory: MockCoordinatorFactory()
        )
        // When
        let result = await coordinator.deleteCreditCard(id: UUID())
        // Then
        XCTAssertEqual(result, .success)
    }
    
    func test_signOut() {
        // Given
        let navigationController = UINavigationController()
        let coordinator = CardListCoordinator(
            viewControllerFactory: MockMainViewControllerFactory(),
            navigationController: navigationController,
            coordinatorFactory: MockCoordinatorFactory()
        )
        // When
        coordinator.signOut()
    }

}
