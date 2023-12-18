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
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        coordinator = AddCreditCardCoordinator(navigationController: navigationController, factory: AddCreditCardViewControllerFactoryMock(), coordinatorFactory: AddCreditCardCoordinatorFactoryMock())
    }

    override func tearDown() {
        super.tearDown()
        navigationController = nil
        coordinator = nil
    }

    func test_Start() {
        //when
        coordinator.start()
        //then
        XCTAssertEqual(self.navigationController.viewControllers.count, 1)
        XCTAssertTrue(self.navigationController.topViewController is AddCreditCardViewController)
    }

    func test_startVisionCoordinator() {
        //given
        //when
        coordinator.testHooks.startVisionKitCoordinator()
        //then
        XCTAssertTrue(navigationController.presentedViewController is VisionKitViewControllerProtocol)
    }
    
//    func test_visionCoordinatorOnFinish() {
//        //given
//        let creditCard: CreditCard = .init(number: 1234, cvv: 1234, date: "11/11", cardName: "SomeName", cardHolderName: "Juan")
//        let viewModel = coordinator.testHooks.addCreditCardVCViewModel
//        //when
//        coordinator.testHooks.startVisionKitCoordinator()
//        visionKitCoordinator.finish(.successfulScan(creditCard))
//        //then
//        
//        XCTAssertEqual(viewModel.creditCardDate, "11/11")
//        XCTAssertEqual(viewModel.creditCardName, "SomeName")
//        XCTAssertEqual(viewModel.creditCardHolderName, "Juan")
//        XCTAssertEqual(viewModel.creditCardNumber, 1234)
//    }
}
