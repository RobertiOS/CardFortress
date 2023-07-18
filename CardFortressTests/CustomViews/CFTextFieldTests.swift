//
//  CFTextFieldTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/16/23.
//

import XCTest
@testable import CardFortress

class CFTextFieldTests: XCTestCase {
    
    var textField: CFTextField!
    
    override func setUp() {
        super.setUp()
        
        let viewModel = CFTextField.ViewModel(
            placeHolder: "Enter text",
            labelText: "Text Field",
            color: .blue,
            tag: 1,
            errorTextLabel: "Invalid input"
        )
        
        textField = CFTextField(viewModel: viewModel)
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    func testTextFieldInitialization() {
        XCTAssertEqual(textField.placeHolder, "Enter text")
        XCTAssertEqual(textField.labelText, "Text Field")
        XCTAssertEqual(textField.testHooks.textField.layer.borderColor, UIColor.blue.cgColor)
        XCTAssertEqual(textField.testHooks.textField.tag, 1)
        XCTAssertEqual(textField.testHooks.errorLabel.text, "Invalid input")
        XCTAssertTrue(textField.testHooks.errorLabel.isHidden)
    }
    
    func testTextFieldErrorVisibility() {
        textField.setErrorVisible(visible: true)
        XCTAssertFalse(textField.testHooks.errorLabel.isHidden)
        
        textField.setErrorVisible(visible: false)
        XCTAssertTrue(textField.testHooks.errorLabel.isHidden)
    }
    
    func testTextFieldText() {
        textField.text = "Hello"
        XCTAssertEqual(textField.text, "Hello")
    }
    
}
