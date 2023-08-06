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
    var navigationController: UINavigationController!
    var mockTabBarCoordinatorFactory: MockTabBarCoordinatorFactory!
    var viewControllerFactory: MockMainViewControllerFactory!
    var mockCoordinatorFactory: MockCoordinatorFactory!
    
    override func setUp() {
        super.setUp()
        viewControllerFactory = .init()
        navigationController = UINavigationController()
        mockTabBarCoordinatorFactory = MockTabBarCoordinatorFactory()
        mockCoordinatorFactory = MockCoordinatorFactory()
        let window = UIWindow()
        coordinator = .init(
            window: window,
            container: Container(),
            coordinatorFactory: mockCoordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
    }
    
    override func tearDown() {
        super.tearDown()
        coordinator = nil
        navigationController = nil
        mockTabBarCoordinatorFactory = nil
        viewControllerFactory = nil
    }
    
    func test_starCoordinator() {
        //given
        let loginCoordinator = mockCoordinatorFactory.loginCoordinator
        //when
        coordinator.start()
        //then
        XCTAssertEqual(loginCoordinator.startCalledCount, 1)
    }
    
    func test_loginCoordinatorFinish() {
        //given
        let loginCoordinator = mockCoordinatorFactory.loginCoordinator
        let tabBarCoordinator = mockCoordinatorFactory.tabBarCoordinator
        //then
        
        XCTAssertEqual(tabBarCoordinator.startCalledCount, 0)
        
        //when
        coordinator.start()
        loginCoordinator.finish(.success)
        
        //then
        XCTAssertEqual(tabBarCoordinator.startCalledCount, 1)
        
    }

}
