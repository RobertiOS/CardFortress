//
//  CardFortressRootCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/6/23.
//

import XCTest
@testable import CardFortress
import Swinject

final class CardFortressRootCoordinatorTests: XCTestCase {

    var coordinator: CardFortressTabBarCoordinator!
    var container: Container!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow(frame: UIScreen.main.bounds)
        container = .init()
        container.register(CardListServiceProtocol.self) { r in
            MockListService()
        }
        coordinator = .init(window: window, container: container)
        coordinator.start()
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        super.tearDown()
        coordinator = nil
        container = nil
    }
    
    func test_Initialization() {
        let viewControllers = coordinator.testHooks.tabs.map { $0.coordinator.navigationController }
        XCTAssertEqual(coordinator.testHooks.tabs.count, 2)
        XCTAssertEqual(viewControllers, coordinator.testHooks.tabBarController.viewControllers)
    }
    

}
