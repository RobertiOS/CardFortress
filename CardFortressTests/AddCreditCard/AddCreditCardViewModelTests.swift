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

    func testAddCreditCard() {
        
        let expectation = self.expectation(description: "Wait for the card to be added")
        
        viewModel.creditCardDate = "123"
        viewModel.creditCardNumber = "123"
        viewModel.creditCardHolderName = "some name"
        
        viewModel.createAddCreditCardPublisher()?
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { result in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: .defaultWait)
    }
}
