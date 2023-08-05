//
//  TabBarCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/6/23.
//

import XCTest
@testable import CardFortress

final class TabBarCoordinatorTests: XCTestCase {

    var coordinator: TabBarCoordinator!
    var navigationController: UINavigationController!
    var mockTabBarCoordinatorFactory: MockTabBarCoordinatorFactory!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        mockTabBarCoordinatorFactory = MockTabBarCoordinatorFactory()
        coordinator = .init(coordinatorFactory: mockTabBarCoordinatorFactory, navigationController: navigationController)
    }
    
    override func tearDown() {
        super.tearDown()
        coordinator = nil
        navigationController = nil
        mockTabBarCoordinatorFactory = nil
    }
    
    func test_Initialization() {
        //given
        let viewControllers: [UIViewController]
        //when
        coordinator.start()
        viewControllers = coordinator.testHooks.tabs.map { $0.coordinator.navigationController }
        //then
        XCTAssertEqual(coordinator.testHooks.tabs.count, 2)
        let tabBarController = coordinator.testHooks.tabBarController
        XCTAssertEqual(viewControllers, tabBarController.viewControllers)
    }

    func test_viewControllerIsPresented() {
        //when
        coordinator.start()
        //then
        XCTAssertTrue(navigationController.topViewController is UITabBarController)
        let tabBarController = coordinator.testHooks.tabBarController
        XCTAssertEqual(tabBarController.viewControllers, mockTabBarCoordinatorFactory.viewControllers)
    }
    
    func test_tabBarCoordinatorIndex() {
        //given
        let addTitle = "Add New"
        let listTitle = "Cards"
        
        let addImage = UIImage(systemName: "rectangle.stack.badge.plus")
        let listImage = UIImage(systemName: "list.bullet.rectangle")
        
        let addSelectedImage = UIImage(systemName: "rectangle.stack.fill.badge.plus")
        let listSelectedImage = UIImage(systemName: "list.bullet.rectangle.fill")
        
        //then
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.add.title,
            addTitle
        )
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.add.image,
            addImage
        )
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.add.selectedImage,
            addSelectedImage
        )
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.main.title,
            listTitle
        )
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.main.image,
            listImage
        )
        
        XCTAssertEqual(
            TabBarCoordinatorIndex.main.selectedImage,
            listSelectedImage
        )
    }

}
