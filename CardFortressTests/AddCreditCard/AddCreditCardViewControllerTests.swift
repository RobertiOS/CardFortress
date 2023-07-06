////
////  AddCreditCardViewControllerTests.swift
////  CardFortressTests
////
////  Created by Roberto Corrales on 7/4/23.
////
//
//@testable import CardFortress
//import XCTest
//import Combine
//
//final class AddCreditCardViewControllerTests: XCTestCase {
//
//    var viewModel: AddCreditCardViewModelProtocol!
//    var subscriptions: Set<AnyCancellable>!
//    
//    
//    override func setUp() {
//        viewModel = AddCreditCardViewModelMock()
//        subscriptions = .init()
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        subscriptions = nil
//    }
//
//    func test_initialization_modelWithNilProperties() {
//        //given
//        let viewController = AddCreditCardViewController(viewModel: viewModel)
//        viewController.loadViewIfNeeded()
//        //when
//        
//        //then
//        XCTAssertEqual(viewController.testHooks.numberTextField.text, "")
//        XCTAssertEqual(viewController.testHooks.cardNameTextField.text, "")
//        XCTAssertEqual(viewController.testHooks.cardHolderNameTextField.text, "")
//        XCTAssertEqual(viewController.testHooks.expirationDateTextField.text, "" )
//        
//        XCTAssertEqual(viewController.testHooks.numberTextField.placeholder, "0000 0000 0000 0000")
//        XCTAssertEqual(viewController.testHooks.cardNameTextField.placeholder, "e.g: Bank Name")
//        XCTAssertEqual(viewController.testHooks.cardHolderNameTextField.placeholder, "Juan Perez")
//        XCTAssertEqual(viewController.testHooks.expirationDateTextField.placeholder, "MM / YY")
//        XCTAssertEqual(viewController.title, "Add New Card")
//        XCTAssertEqual(viewController.testHooks.cardNameLabel.text, "Card Name")
//        XCTAssertEqual(viewController.testHooks.expirationDateLabel.text, "Expiration Date")
//        XCTAssertEqual(viewController.testHooks.cardNumberLabel.text, "Card Number")
//        XCTAssertEqual(viewController.testHooks.cardHolderLabel.text, "Card Holder Name")
//    }
//}
