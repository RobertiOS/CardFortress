//
//  AuthCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import XCTest
import SwiftUI
@testable import CardFortress

final class AuthCoordinatorTests: XCTestCase {

    var coordinator: AuthCoordinator!
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        navigationController = UINavigationController()
        coordinator = .init(
            factory: AuthenticationFactoryMock(),
            authenticationAPI: AuthenticationAPIMock(),
            secureUserDataAPI: SecureUserDataAPIMock(),
            window: window,
            navigationController: navigationController
        )
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        super.tearDown()
        coordinator = nil
        navigationController = nil
    }
    
    func test_startCoordinator() throws {
        //when
        XCTAssertEqual(navigationController.viewControllers.count, 0)
        XCTAssertNil(navigationController.topViewController)
        coordinator.start()
        //then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    func test_startCreateUser() throws {
        //when
        XCTAssertEqual(navigationController.viewControllers.count, 0)
        XCTAssertNil(navigationController.topViewController)
        coordinator.start()
        coordinator.startCreateUser()
        
        //then
        XCTAssertEqual(navigationController.viewControllers.count, 1)
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
    
    @MainActor
    func test_CreateUser() async {
        //when
        coordinator.start()
        let result = await coordinator.createUser(name: "", lastName: "", email: "", password: "")
        //then
        XCTAssertEqual(result, .success)
    }
    
    func test_getUserCredentials() async {
        // When
        let userCredentials: (email: String, password: String)? = await coordinator.getUserCredentials()
        // Then
        XCTAssertEqual(userCredentials?.email, "User")
        XCTAssertEqual(userCredentials?.password, "1234")
    }
    
    func test_signInWithBiometrics() async throws {
        // When
        let loginResult = await coordinator.loginWithBiometrics()
        // Then
        XCTAssertEqual(loginResult, .success)
    }

}
