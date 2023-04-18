//
//  MainViewControllerTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 16/04/23.
//

import XCTest
@testable import CardFortress

final class MainViewControllerTests: XCTestCase {

    func testViewControllerStringsAreCorrect() throws {
        //given //when
        let viewcontroller = MainViewController()

        //then
        XCTAssertEqual(viewcontroller.testHooks.buttonTitleText, "Go to other view")
        XCTAssertEqual(viewcontroller.testHooks.labelText, "Card fortress app")
        XCTAssertEqual(viewcontroller.testHooks.viewControllerTitle, "Main View")
    }
}
