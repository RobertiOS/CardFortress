//
//  SecureStoreTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 30/04/23.
//

import XCTest
@testable import CardFortress
import Combine

final class SecureStoreTests: XCTestCase {
    var secureStore: SecureStoreProtocol!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let cardQueryable = CreditCardSSQueryable(service: "CreditCards")
        secureStore = SecureStore(sSQueryable: cardQueryable)
        subscriptions = .init()
    }

    override func tearDownWithError() throws {
        _ = secureStore.removeAllCreditCards()
        secureStore = nil
        subscriptions = nil
    }

    func testSaveCreditCard() throws {
        let creditCard = CreditCard(identifier: UUID(), number: 111, cvv: 111, date: "12221", cardName: "Visa", cardHolderName: "Juan Perez")
        let expectation = self.expectation(description: "save card")
        
        secureStore.addCreditCardToKeychain(creditCard)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { value in
                if case .success = value {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 0.3)

    }
    
    func testGetCard() throws {
        
        //given
        let creditCard = try secureStore.getCreditCardFromKeychain(identifier: UUID())
        let creditCard2 = CreditCard(identifier: UUID(), number: 111, cvv: 111, date: "12221", cardName: "Visa", cardHolderName: "Juan Perez")
            
        // when
        addCreditCardToKeychainHelper(creditCard2)
        let getCard2 = try secureStore.getCreditCardFromKeychain(identifier: creditCard2.identifier)

        // then
        XCTAssertNil(creditCard)
        XCTAssertNotNil(getCard2)
        XCTAssertEqual(getCard2, creditCard2)
    }
    
    func testUpdateCreditCardIformation() throws {
        
        //given
        let identifier = UUID()
        let mockCard = CreditCard(identifier: identifier, number: 111, cvv: 111, date: "12221", cardName: "Visa", cardHolderName: "Juan Perez")
            
        // when
        addCreditCardToKeychainHelper(mockCard)
        let queriedCard = try secureStore.getCreditCardFromKeychain(identifier: identifier)
        var creditCard = try XCTUnwrap(queriedCard)
        // then
        XCTAssertEqual(creditCard.number, 111)
        XCTAssertEqual(creditCard.cvv, 111)
        XCTAssertEqual(creditCard.date, "12221")
        XCTAssertEqual(creditCard.cardName, "Visa")
        
        // when
        creditCard.date = "11/22/11"
        creditCard.cvv = 123
        creditCard.cardName = "Test"
        creditCard.number = 123421234
        creditCard.identifier = identifier
        addCreditCardToKeychainHelper(creditCard)
        
        let queriedCard2 = try secureStore.getCreditCardFromKeychain(identifier: identifier)
        let creditCard2 = try XCTUnwrap(queriedCard2)
        
        // then
        XCTAssertEqual(creditCard2.number, 123421234)
        XCTAssertEqual(creditCard2.cvv, 123)
        XCTAssertEqual(creditCard2.date, "11/22/11")
        XCTAssertEqual(creditCard2.cardName, "Test")
    }
    
    func testGetAllCards() throws {
        //given
        
        let mockCard = CreditCard(number: 111, cvv: 111, date: "12221", cardName: "Visa", cardHolderName: "Juan Perez")
            
        // when
        addCreditCardToKeychainHelper(mockCard)
        
        let expectation = self.expectation(description: "wait for cards")
        //when
        secureStore.getAllCreditCardsFromKeychain()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                }
            } receiveValue: { creditCards in
                expectation.fulfill()
                XCTAssertNotNil(creditCards)
                XCTAssertFalse(creditCards.isEmpty)
                
            }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1)
    }
    
    func testDeleteAllCards() {
        //given
        let expectation = self.expectation(description: "Delete all cards")
        
        //when
        secureStore.removeAllCreditCards()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { status in
                switch status {
                case .success:
                    expectation.fulfill()
                case .failure( let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1)
    }

    func addCreditCardToKeychainHelper(_ creditCard: CreditCard) {
        let expectation = self.expectation(description: "Store card to keychain")
        secureStore.addCreditCardToKeychain(creditCard)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        waitForExpectations(timeout: 0.3)
    }
}
