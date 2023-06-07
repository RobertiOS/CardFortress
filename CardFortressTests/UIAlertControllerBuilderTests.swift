//
//  UIAlertControllerBuilderTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/17/23.
//

import XCTest
@testable import CardFortress

class UIAlertControllerBuilderTests: XCTestCase {

    func testBuilderWithTitle() {
        let builder = UIAlertController.Builder()
        builder.withTitle("Test Title")
        XCTAssertEqual(builder.testHooks.title, "Test Title")
    }

    func testBuilderWithMessage() {
        let builder = UIAlertController.Builder()
        builder.withMessage("Test Message")
        XCTAssertEqual(builder.testHooks.message, "Test Message")
    }

    func testBuilderWithButton() {
        let builder = UIAlertController.Builder()
        builder.withButton(title: "Test Button")
        XCTAssertEqual(builder.testHooks.actions.count, 1)
        XCTAssertEqual(builder.testHooks.actions.first?.title, "Test Button")
    }

    func testBuilderWithAlertStyle() {
        let builder = UIAlertController.Builder()
        builder.withAlertStyle(.actionSheet)
        XCTAssertEqual(builder.testHooks.alertStyle, .actionSheet)
    }

    func testBuilderWithTextField() {
        let builder = UIAlertController.Builder()
        builder.withTextField(true)
        XCTAssertTrue(builder.testHooks.showTextField)
    }

    func testBuilderAddTextField() {
        let builder = UIAlertController.Builder()
        let textFields: [((UITextField) -> Void)?] = [{ textField in
            textField.placeholder = "Test Placeholder"
        }]
        builder.addTextField(textFields)
        XCTAssertEqual(builder.testHooks.textFields?.count, 1)
    }

    func testBuilderAddActions() {
        let builder = UIAlertController.Builder()
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "Test Action 1", style: .default, handler: nil),
            UIAlertAction(title: "Test Action 2", style: .cancel, handler: nil)
        ]
        builder.addActions(actions)
        XCTAssertEqual(builder.testHooks.actions.count, 2)
        XCTAssertEqual(builder.testHooks.actions.first?.title, "Test Action 1")
        XCTAssertEqual(builder.testHooks.actions.last?.title, "Test Action 2")
    }
}

class UIViewControllerAlertTests: XCTestCase {

    func testPresentAlert() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        let error = NSError(domain: "Test Error", code: 0, userInfo: nil)
        viewController.presentAlert(with: error)
        let expectation = XCTestExpectation(description: "Alert presented")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let presentedViewController = viewController.presentedViewController as? UIAlertController
                XCTAssertNotNil(presentedViewController)
                XCTAssertEqual(presentedViewController?.title, "Error")
                XCTAssertEqual(presentedViewController?.message, error.localizedDescription)
                XCTAssertEqual(presentedViewController?.actions.count, 1)
                XCTAssertEqual(presentedViewController?.actions.first?.title, "OK")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2)
    }
}
