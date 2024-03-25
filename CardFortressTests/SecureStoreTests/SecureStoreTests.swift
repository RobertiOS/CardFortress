//
//  SecureStoreTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/20/23.
//

import XCTest
@testable import CFAPIs


final class SecureStoreTests: XCTestCase {
    
    var secureStore: SecureStoreAPI!
    
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
        
        let result = try await secureStore.addCreditCardToKeychain(creditCard)
        XCTAssertEqual(result, .addSuccess)
        
    }
    
    func test_SecureStore_EditCreditCard() async throws {
        //given
        let creditCard: SecureStoreCreditCard = .make()
        try await addCardHelper(creditCard: creditCard, expectedResultType: .addSuccess)
        
        let creditCard2 = try await secureStore.getCreditCardFromKeychain(identifier: creditCard.identifier)
        XCTAssertEqual(creditCard, creditCard2)
        
        // add an edited card with the same identifier as the first card
        
        let editedCreditCard = SecureStoreCreditCard(
            identifier: creditCard.identifier,
            number: "123",
            cvv: 123,
            date: "11/22",
            cardName: "Visa",
            cardHolderName: "Pablo"
        )
        
        try await addCardHelper(creditCard: editedCreditCard, expectedResultType: .editSuccess)
        
        //when
        
        let creditCard3 = try await secureStore.getCreditCardFromKeychain(identifier: creditCard.identifier)
        XCTAssertEqual(editedCreditCard, creditCard3)
        
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
        await fulfillment(of: [expectation], timeout: .defaultWait, enforceOrder: true)
    }
    
    func test_SecureStore_GetAllCreditCards() async throws {
        //given
        try await addCardHelper(creditCard: .make())
        try await addCardHelper(creditCard: .make())
        
        //then
        let creditCards = try await secureStore.getAllCreditCardsFromKeychain()
        XCTAssertEqual(creditCards.count, 2)
    }
    
    
    func addCardHelper(creditCard: SecureStoreCreditCard, expectedResultType: SecureStoreResult = .addSuccess) async throws {
        let result = try await secureStore.addCreditCardToKeychain(creditCard)
        XCTAssertEqual(result, expectedResultType)
    }
    
    func removeAllCardsHelper() async throws {
        try await secureStore.removeAllCreditCards()
    }
}
