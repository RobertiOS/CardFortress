//
//  AddCreditCardViewControllerTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/4/23.
//

@testable import CardFortress
import XCTest
import Combine

final class AddCreditCardViewControllerTests: XCTestCase {

    var viewModel: AddCreditCardViewController.ViewModel!
    var subscriptions: Set<AnyCancellable>!
    
    
    override func setUp() {
        viewModel = .init(service: MockListService())
        subscriptions = .init()
    }
    
    override func tearDown() {
        viewModel = nil
        subscriptions = nil
    }

    func test_initialization_modelWithNilProperties() {
        //given
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        //when
        viewController.loadViewIfNeeded()
        //then
        XCTAssertEqual(viewController.testHooks.numberTextField.text, "")
        XCTAssertEqual(viewController.testHooks.cardNameTextField.text, "")
        XCTAssertEqual(viewController.testHooks.nameOnCardTextField.text, "")
        XCTAssertEqual(viewController.testHooks.expiryDateTextField.text, "" )
        XCTAssertEqual(viewController.testHooks.expiryDateTextField.text, "" )
        
        XCTAssertEqual(viewController.testHooks.numberTextField.placeHolder, "0000 0000 0000 0000")
        XCTAssertEqual(viewController.testHooks.cardNameTextField.placeHolder, "e.g: Bank Name")
        XCTAssertEqual(viewController.testHooks.nameOnCardTextField.placeHolder, "Juan Perez")
        XCTAssertEqual(viewController.testHooks.expiryDateTextField.placeHolder, "MM / YY")
        XCTAssertEqual(viewController.testHooks.cvvTextField.placeHolder, "123")
        XCTAssertEqual(viewController.title, "New Card")
        
        XCTAssertEqual(viewController.testHooks.cardNameTextField.labelText, "CARD NAME")
        XCTAssertEqual(viewController.testHooks.expiryDateTextField.labelText, "EXPIRY DATE")
        XCTAssertEqual(viewController.testHooks.numberTextField.labelText, "CARD NUMBER")
        XCTAssertEqual(viewController.testHooks.nameOnCardTextField.labelText, "NAME ON CARD")
        XCTAssertEqual(viewController.testHooks.cvvTextField.labelText, "CVV")
    }
}
