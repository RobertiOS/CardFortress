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

//    func test_loginCoordinatorFinish() {
//        //given
//        let loginCoordinator = mockCoordinatorFactory.loginCoordinator
//        let tabBarCoordinator = mockCoordinatorFactory.tabBarCoordinator
//        //then
//        
//        XCTAssertEqual(tabBarCoordinator.startCalledCount, 0)
//        
//        //when
//        coordinator.start()
//        loginCoordinator.finish(.success)
//        
//        //then
//        XCTAssertEqual(tabBarCoordinator.startCalledCount, 1)
//        
//    }
//    
//    func test_tabBarCoordinatorFinish() {
//        //given
//        let loginCoordinator = mockCoordinatorFactory.loginCoordinator
//        let tabBarCoordinator = mockCoordinatorFactory.tabBarCoordinator
//        
//        //then
//        
//        XCTAssertEqual(loginCoordinator.startCalledCount, 0)
//        XCTAssertNil(loginCoordinator.onFinish)
//        XCTAssertNil(tabBarCoordinator.onFinish)
//        
//        //when
//        coordinator.start()
//        loginCoordinator.finish(.success)
//        
//        //then
//        XCTAssertEqual(loginCoordinator.startCalledCount, 1)
//        XCTAssertEqual(tabBarCoordinator.startCalledCount, 1)
//        
//        //when
//        tabBarCoordinator.finish(.signOut)
//        
//        XCTAssertEqual(loginCoordinator.startCalledCount, 2)
//        
//    }

}
