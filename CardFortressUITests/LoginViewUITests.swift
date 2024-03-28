//
//  LoginViewUITests.swift
//  CardFortressUITests
//
//  Created by Roberto Corrales on 9/10/23.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    

    func testLogin() throws {
        //given
        let app = XCUIApplication()
        app.launchArguments = ["-Tests"]
        app.launch()
        
        //then
        let cardFortressText = app.staticTexts["Credit Card Fortress"]
        XCTAssertTrue(cardFortressText.exists)
        
        //when
        
        let username = app.textFields["Your email"]
        username.tap()
        username.typeText("test")
        
        app.keyboards.buttons["Return"].tap()
        
        let password = app.secureTextFields["Your password"]
        password.tap()
        password.typeText("1234")
        
        app.keyboards.buttons["Return"].tap()
        
        let loginButton = app.buttons["Log in"]
        loginButton.tap()
        
        //then
        let title = app.staticTexts["Card Fortress"]
        XCTAssertTrue(title.waitForExistence(timeout: 0.5))
    }

}
