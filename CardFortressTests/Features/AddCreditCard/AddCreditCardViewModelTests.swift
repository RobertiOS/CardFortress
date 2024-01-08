//
//  AddCreditCardViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/17/23.
//

import XCTest
@testable import CardFortress
import Combine

final class AddCreditCardViewModelTests: XCTestCase {
    
    typealias ViewModel = AddCreditCardViewController.ViewModel
    
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
    
    func testDefaultInitialization() {
        XCTAssertNil(viewModel.creditCardName)
        XCTAssertNil(viewModel.creditCardNumber)
        XCTAssertNil(viewModel.creditCardDate)
        XCTAssertNil(viewModel.creditCardHolderName)
    }
    
    func test_editCreditCard() {
        // Given
        let creditCard: CreditCard = .make(
            number: "1234",
            date: "11/12",
            cardName: "test name",
            cardHolderName: "Juan"
        )
        let viewModel = ViewModel(service: MockListService(), action: .editCreditCard(creditCard))
        
        // Then
        XCTAssertEqual(viewModel.creditCardHolderName, "Juan")
        XCTAssertEqual(viewModel.creditCardDate, "11/12")
        XCTAssertEqual(viewModel.creditCardNumber, "1234")
        XCTAssertEqual(viewModel.creditCardName, "test name")
        // When
        
        let expectation = expectation(
            description: "wait for publisher to emit result"
        )
        
        viewModel.createAddCreditCardPublisher()?
            .sink { _ in
            } receiveValue: { result in
                XCTAssertEqual(result, .success)
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: .defaultWait)
        
    }
    
    func test_addCreditCard() {
        // Given
        let viewModel = ViewModel(service: MockListService(), action: .addCreditCard)
        
        // Then
        XCTAssertNil(viewModel.creditCardHolderName)
        XCTAssertNil(viewModel.creditCardDate)
        XCTAssertNil(viewModel.creditCardNumber)
        XCTAssertNil(viewModel.creditCardName)

        viewModel.creditCardHolderName = "holder name"
        viewModel.creditCardDate = "11/11"
        viewModel.creditCardNumber = "1234"
        viewModel.creditCardName = "name"
        
        // When
        let expectation = expectation(
            description: "wait for publisher to emit result"
        )
        
        _ = viewModel.createAddCreditCardPublisher()?
            .sink { _ in
            } receiveValue: { result in
                XCTAssertEqual(result,.success)
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: .defaultWait)
        
    }
}
