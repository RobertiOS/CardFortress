//
//  AddCreditCardViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/17/23.
//

import XCTest
@testable import CardFortress
import Combine
import CFDomain
import MockSupport

final class AddCreditCardViewModelTests: XCTestCase {
    
    typealias ViewModel = AddCreditCardViewController.ViewModel
    
    var viewModel: AddCreditCardViewController.ViewModel!
    var subscriptions: Set<AnyCancellable>!
    override func setUp() {
        viewModel = .init(addCreditCardUseCase: AddCreditCardsUseCaseMock())
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
        let creditCard = DomainCreditCard(
            identifier: UUID(),
            number: "123",
            cvv: 123,
            date: "123",
            cardName: "Visa",
            cardHolderName: "Juan Perez",
            notes: "notes",
            isFavorite: false
        )
        let viewModel = ViewModel(addCreditCardUseCase: AddCreditCardsUseCaseMock(), action: .editCreditCard(creditCard))
        
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
                XCTAssertNotNil(result)
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: .defaultWait)
        
    }
    
    func test_addCreditCard() {
        // Given
        let viewModel = ViewModel(addCreditCardUseCase: AddCreditCardsUseCaseMock(), action: .addCreditCard)
        
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
                XCTAssertNotNil(result)
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: .defaultWait)
        
    }
}
