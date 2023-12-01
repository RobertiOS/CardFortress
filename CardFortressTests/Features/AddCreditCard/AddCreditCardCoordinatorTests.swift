//
//  AddCreditCardCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 6/27/23.
//

import XCTest
import Swinject
import VisionKit
@testable import CardFortress

final class AddCreditCardCoordinatorTests: XCTestCase {

    var navigationController: UINavigationController!
    var coordinator: AddCreditCardCoordinator!
    var coordinatorFactory: MockCoordinatorFactory!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        coordinatorFactory = MockCoordinatorFactory()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        coordinator = AddCreditCardCoordinator(
            navigationController: navigationController,
            factory: MockMainViewControllerFactory(),
            coordinatorFactory: coordinatorFactory)
    }

    override func tearDown() {
        super.tearDown()
        navigationController = nil
        coordinator = nil
        coordinatorFactory = nil
    }

    func test_Start() {
        //when
        coordinator.start()
        //then
        XCTAssertEqual(self.navigationController.viewControllers.count, 1)
        XCTAssertTrue(self.navigationController.topViewController is AddCreditCardViewControllerProtocol)
    }

    func test_startVisionCoordinator() {
        //given
        let mockVisionCoordinator = coordinatorFactory.visionKitCoordinator
        //when
        XCTAssertEqual(mockVisionCoordinator.startCalledCount, 0)
        coordinator.testHooks.startVisionKitCoordinator()
        //then
        XCTAssertEqual(mockVisionCoordinator.startCalledCount, 1)
    }
    
    func test_visionCoordinatorOnFinish() {
        //given
        let visionKitCoordinator = coordinatorFactory.visionKitCoordinator
        let creditCard: CreditCard = .init(number: 1234, cvv: 1234, date: "11/11", cardName: "SomeName", cardHolderName: "Juan")
        let viewModel = coordinator.testHooks.addCreditCardVCViewModel
        //when
        coordinator.testHooks.startVisionKitCoordinator()
        
        //then
        XCTAssertNil(viewModel.creditCardDate)
        XCTAssertNil(viewModel.creditCardName)
        XCTAssertNil(viewModel.creditCardHolderName)
        XCTAssertNil(viewModel.creditCardNumber)
        
        //when
        visionKitCoordinator.finish(.successfulScan(creditCard))
        //then
        
        XCTAssertEqual(viewModel.creditCardDate, "11/11")
        XCTAssertEqual(viewModel.creditCardName, "SomeName")
        XCTAssertEqual(viewModel.creditCardHolderName, "Juan")
        XCTAssertEqual(viewModel.creditCardNumber, 1234)
    }
}
