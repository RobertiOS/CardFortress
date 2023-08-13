//
//  LoginCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import XCTest
@testable import CardFortress

final class LoginCoordinatorTests: XCTestCase {

    var coordinator: AuthCoordinator!
    var navigationController: UINavigationController!
    var factory: AuthenticationFactoryMock!
    
    override func setUp() {
        super.setUp()
        factory = AuthenticationFactoryMock()
        navigationController = UINavigationController()
        coordinator = .init(
            factory: factory,
            navigationController: navigationController,
            authenticationAPI: AuthenticationAPIMock())
    }

    override func tearDown() {
        super.tearDown()
        coordinator = nil
        navigationController = nil
        factory = nil
    }
    
    func test_startCoordinator() {
        //given
        let loginViewController = factory.loginViewController
        //when
        XCTAssertEqual(navigationController.viewControllers.count, 0)
        XCTAssertNil(navigationController.topViewController)
        coordinator.start()
        //then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.topViewController, loginViewController)
    }
    
    @MainActor
    func test_login() async {
        //given
        let emailPassword = "user"
        let password = "password"
        //when
        coordinator.start()
        let result = await coordinator.login(email: emailPassword, password: password)
        //then
        XCTAssertEqual(result, .success)
    }

}
