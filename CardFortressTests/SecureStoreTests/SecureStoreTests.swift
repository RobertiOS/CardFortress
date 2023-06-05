//
//  SecureStoreTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/20/23.
//

import XCTest
@testable import CardFortress


final class SecureStoreTests: XCTestCase {

    var secureStore: SecureStoreProtocol!

    override func setUp() {
        super.setUp()
        secureStore = SecureStore(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
    }
    
    override func tearDown() async throws {
        try await removeAllCardsHelper()
        secureStore = nil
    }

    func test_SecureStore_AddCreditCard() async throws {
        //given
        let creditCard: SecureStoreCreditCard = .make()

        //when
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStore.addCreditCardToKeychain(creditCard)
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

    func test_SecureStore_EditCreditCard() async throws {
        //given
        let creditCard: SecureStoreCreditCard = .make()
        try await addCardHelper(creditCard: creditCard)

        let getCardExpectation = expectation(description: "get credit card")
        Task {
            let creditCard2 = try await secureStore.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(creditCard, creditCard2)
            getCardExpectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)

        // add an edited card with the same identifier as the first card

        let editedCreditCard = SecureStoreCreditCard(
            identifier: creditCard.identifier,
            number: 123,
            cvv: 123,
            date: "11/22",
            cardName: "Visa",
            cardHolderName: "Pablo"
        )

        try await addCardHelper(creditCard: editedCreditCard)

        //when
        let getCardEditedCardExpectation = expectation(description: "get edited card")
        Task {
            let creditCard3 = try await secureStore.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(editedCreditCard, creditCard3)
            getCardEditedCardExpectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

    func test_SecureStore_GetCreditCard() async throws {
        //given
        let creditCard: SecureStoreCreditCard = .make()

        //when
        try await addCardHelper(creditCard: creditCard)
        let expectation = expectation(description: "get credit card")
        Task {
            let creditCard2 = try await secureStore.getCreditCardFromKeychain(identifier: creditCard.identifier)
            XCTAssertEqual(creditCard, creditCard2)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

    func test_SecureStore_GetAllCreditCards() async throws {
        //given
        try await addCardHelper(creditCard: .make())
        try await addCardHelper(creditCard: .make())

        //then
        let expectation = expectation(description: "get credit card")
        Task {
            let creditCards = try await secureStore.getAllCreditCardsFromKeychain()
            XCTAssertEqual(creditCards.count, 2)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }


    func addCardHelper(creditCard: SecureStoreCreditCard) async throws {
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStore.addCreditCardToKeychain(creditCard)
            XCTAssertEqual(result, .success)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }

    func removeAllCardsHelper() async throws {
        let expectation = expectation(description: "delete credit cards")
        Task {
            try await secureStore.removeAllCreditCards()
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }
}
