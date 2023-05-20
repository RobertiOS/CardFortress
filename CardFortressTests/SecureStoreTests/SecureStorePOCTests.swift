//
//  SecureStorePOCTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/20/23.
//

import XCTest
@testable import CardFortress


final class SecureStorePOCTests: XCTestCase {
    
    var secureStorePOC: SecureStoreProtocolPOC!
    
    
    override func setUp() {
        super.setUp()
        secureStorePOC = SecureStorePOC(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
    }
    
    override func tearDown() async throws {
        try await removeAllCardsHelper()
        secureStorePOC = nil
    }

    func test_SecureStore_AddCreditCard() async throws {
        //given
        let creditCard: CreditCard = .make()
        
        //when
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStorePOC.addCreditCardToKeychain(creditCard)
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }
    
    func test_SecureStore_EditCreditCard() async throws {
        //given
        let creditCard: CreditCard = .make()
        await addCardHelper(creditCard: creditCard)
        
        let getCardExpectation = expectation(description: "get credit card")
        Task {
            let result = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(creditCard, result)
            getCardExpectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
        
        // add an edited card with the same identifier as the first card
        
        let editedCreditCard = CreditCard(
            identifier: creditCard.identifier,
            number: 123,
            cvv: 123,
            date: "11/22",
            cardName: "Visa",
            cardHolderName: "Pablo"
        )
        
        await addCardHelper(creditCard: editedCreditCard)
        
        //when
        let getCardEditedCardExpectation = expectation(description: "get edited card")
        Task {
            let result = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(editedCreditCard, result)
            getCardEditedCardExpectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }
    
    func test_SecureStore_GetCreditCard() async throws {
        //given
        let creditCard: CreditCard = .make()
        
        //when
        await addCardHelper(creditCard: creditCard)
        let expectation = expectation(description: "get credit card")
        Task {
            let result = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(creditCard, result)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }
    
    func test_SecureStore_GetAllCreditCards() async throws {
        //given
        await addCardHelper(creditCard: .make())
        await addCardHelper(creditCard: .make())
        
        //then
        let expectation = expectation(description: "get credit card")
        Task {
            let result = try await secureStorePOC.getAllCreditCardsFromKeychain()
            XCTAssertEqual(result?.count, 2)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

    
    func addCardHelper(creditCard: CreditCard) async {
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStorePOC.addCreditCardToKeychain(creditCard)
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }
    
    func removeAllCardsHelper() async throws {
        let expectation = expectation(description: "delete credit cards")
        Task {
            try await secureStorePOC.removeAllCreditCards()
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

}
