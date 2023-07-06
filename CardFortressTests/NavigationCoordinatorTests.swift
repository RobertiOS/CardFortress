//
//  NavigationCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 3/05/23.
//
@testable import CardFortress
import XCTest

class NavigationCoordinatorTests: XCTestCase {
    
    var navigationCoordinator: MockNavigationCoordinator!
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        navigationCoordinator = MockNavigationCoordinator(navigationController: navigationController)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        navigationController = nil
        navigationCoordinator = nil
        super.tearDown()
    }
    
    func testNavigateTo_PresentationStyle_Present() {
        // Given
        let viewController = UIViewController()
        let presentationStyle: PresentationStyle = .present(completion: nil)
        // When
        navigationCoordinator.navigateTo(viewController, presentationStyle: presentationStyle)
        let presentedViewController = navigationController.presentedViewController

        // Then
        XCTAssertTrue(presentedViewController == viewController)
    }
    
    func testNavigateTo_PresentationStyle_Push() {
        // Given
        let viewController = UIViewController()
        let presentationStyle: PresentationStyle = .push
        // When
        navigationCoordinator.navigateTo(viewController, presentationStyle: presentationStyle)
        let presentedViewController = navigationController.topViewController

        // Then
        XCTAssertTrue(presentedViewController == viewController)
    }

    
}

class MockNavigationCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
