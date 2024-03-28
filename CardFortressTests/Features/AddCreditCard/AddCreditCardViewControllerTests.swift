//
//  AddCreditCardViewControllerTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/4/23.
//

@testable import CardFortress
import XCTest
import Combine
import Domain

final class AddCreditCardViewControllerTests: XCTestCase {

    func test_initialization_modelWithNilProperties() {
        //given
        let viewController = AddCreditCardViewController(viewModel: AddCreditCardViewController.ViewModel(addCreditCardUseCase: AddCreditCardsUseCaseMock()))
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
    
    func test_keyboardObservers() {
        // Given
        let viewController = AddCreditCardViewController(viewModel: AddCreditCardViewController.ViewModel(addCreditCardUseCase: AddCreditCardsUseCaseMock()))
        viewController.loadViewIfNeeded()
        let scrollView = viewController.testHooks.scrollView
        
        // Then
        XCTAssertEqual(scrollView.contentInset.bottom, 0.0)
        XCTAssertEqual(scrollView.verticalScrollIndicatorInsets.bottom, 0.0)
        // When
        NotificationCenter.default.post(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [UIResponder.keyboardFrameEndUserInfoKey: CGRect(x: 0, y: 0, width: 0, height: 300)]
        )
        
        XCTAssertEqual(scrollView.contentInset.bottom, 300.0)
        
        // When
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)

        // Then
        XCTAssertEqual(scrollView.contentInset.bottom, 0.0)
        XCTAssertEqual(scrollView.verticalScrollIndicatorInsets.bottom, 0.0)

    }
}
