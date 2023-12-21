//
//  CardFortressAppCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import XCTest
import Swinject
@testable import CardFortress

final class CardFortressAppCoordinatorTests: XCTestCase {

    var coordinator: CardFortressAppCoordinator!
    var window: UIWindow!
    override func setUp() {
        super.setUp()
        window = UIWindow()
        coordinator = .init(window: window, container: .mockContainer, coordinatorFactory: CardFortressCoordinatorFactory(container: .mockContainer))
    }
    
    override func tearDown() {
        super.tearDown()
        coordinator = nil
        window = nil
    }
    
    func test_starCoordinator() throws {
        //when
        coordinator.start()
        //then
        let navigationController = try XCTUnwrap(window.rootViewController as? UINavigationController)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func test_loginCoordinatorStart() {
        //when
        coordinator.startLoginCoordinator()
        
        //then
        XCTAssertTrue(window.rootViewController is UINavigationController)
        let navigationController = window.rootViewController as? UINavigationController
        
        XCTAssertTrue(navigationController?.topViewController is  UIHostingControllerWrapper<LoginView>)
    }
    
    func test_tabBarCoordinatorStart() {
        //when
        coordinator.startTabBarCoordinator()
        
        
        //then
        XCTAssertTrue(window.rootViewController is UITabBarController)
        
    }

}
