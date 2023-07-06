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
        
        let container = Container()
        coordinator = AddCreditCardCoordinator(
            navigationController: navigationController,
            containter: container,
            factory: AddCreditCardMockFactory())
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
        XCTAssertTrue(self.navigationController.topViewController is AddCreditCardViewControllerProtocol)
    }

    func test_startVisionCoordinator() {
        //when
        coordinator.testHooks.startVisionKitCoordinator()
        //then
        XCTAssertTrue(self.navigationController.presentedViewController is VisionKitViewControllerProtocol)
    }

}
