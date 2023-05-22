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
        let endcodedCreditCard = try makeEncodedCardHelper()

        //when
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStorePOC.addCreditCardToKeychain(endcodedCreditCard)
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
            let data = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            let decodedCreditCard = try JSONDecoder().decode(SecureStoreCreditCard.self, from: data!)
            XCTAssertEqual(creditCard, decodedCreditCard)
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
            let data = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            let decodedCreditCard = try JSONDecoder().decode(SecureStoreCreditCard.self, from: data!)
            XCTAssertEqual(editedCreditCard, decodedCreditCard)
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
            let data = try await secureStorePOC.getCreditCardFromKeychain(identifier: creditCard.identifier)
            let decodedCreditCard = try JSONDecoder().decode(SecureStoreCreditCard.self, from: data!)
            XCTAssertEqual(creditCard, decodedCreditCard)
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
            let result = try await secureStorePOC.getAllCreditCardsFromKeychain()
            XCTAssertEqual(result.count, 2)
            expectation.fulfill()
        }
        await waitForExpectations(timeout: .defaultWait)
    }


    func addCardHelper(creditCard: SecureStoreCreditCard) async throws {
        
        let cardData : [String : Any] = [
            "identifier": creditCard.identifier.uuidString,
            "number": creditCard.number,
            "cvv": creditCard.cvv,
            "date": creditCard.date,
            "cardName": creditCard.cardName,
            "cardHolderName": creditCard.cardHolderName
        ]
        
        let encodedCard = try secureStorePOC.createEncodedCreditCard(for: cardData)
        let expectation = expectation(description: "add credit card")
        Task {
            let result = try await secureStorePOC.addCreditCardToKeychain(encodedCard)
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
    
    func test_EncodeCreditCard() throws {
        //given
        let identifier = UUID().uuidString
        let cardData : [String : Any] = [
            "identifier": identifier,
            "number": 1234,
            "cvv": 123,
            "date": "12/24",
            "cardName": "Card",
            "cardHolderName": "Juan Perez"
        ]
        
        //when
        
        let encodedCard = try secureStorePOC.createEncodedCreditCard(for: cardData)
        let card = try JSONDecoder().decode(SecureStoreCreditCard.self, from: encodedCard.data)
        
        //then
        XCTAssertEqual(encodedCard.identifier, UUID(uuidString: identifier))
        XCTAssertEqual(card.identifier.uuidString, identifier)
        XCTAssertEqual(card.number, 1234)
        XCTAssertEqual(card.date, "12/24")
        XCTAssertEqual(card.cardName, "Card")
        XCTAssertEqual(card.cardHolderName, "Juan Perez")
    }
    
    func test_EncodeCreditCard_MissingKeys() throws {
        //given
        let identifier = UUID().uuidString
        let cardData : [String : Any] = [
            "identifier": identifier,
            "number": 1234,
            "date": "12/24",
            "cardName": "Card",
        ]
        
        //when

        XCTAssertThrowsError(try secureStorePOC.createEncodedCreditCard(for: cardData)) { error in
            XCTAssertEqual(error.localizedDescription, "Missing keys: cvv, cardHolderName")
        }
    }
    
    func makeEncodedCardHelper() throws -> EncodedCard {
        let cardData : [String : Any] = [
            "identifier": UUID().uuidString,
            "number": Int.random(in: 1...40),
            "cvv": Int.random(in: 1...40),
            "date": "124",
            "cardName": "Card \(Int.random(in: 1...40))",
            "cardHolderName": "Juan Perez \(Int.random(in: 1...40))"
        ]
        return try secureStorePOC.createEncodedCreditCard(for: cardData)
    }

}
