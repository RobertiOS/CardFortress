//
//  ListViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 29/04/23.
//

import XCTest
import Combine
@testable import CardFortress

final class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModelProtocol!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let service = MockListService()
        viewModel = ListViewModel(cardListService: service)
        subscriptions = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        subscriptions = nil
    }
    
    func testViewModelFetchCards() {
        
        //given
        var creditCards = [CreditCard]()
        //when
        
        let expectation = self.expectation(description: "fetch cards")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                creditCards = cards
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        

        viewModel.fetchCreditCards()

        waitForExpectations(timeout: 1)
        //then
        
        XCTAssertFalse(creditCards.isEmpty)
        XCTAssertEqual(creditCards.count, 3)
    }
    
    func testAddCreditCard() {
        
        //given
        let creditCard = CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez")
        //when
        
        let expectation = self.expectation(description: "add card")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                XCTAssertEqual(cards.count, 4)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.addCreditCard(creditCard)

        waitForExpectations(timeout: 1)

    }
    
    func testDeleteAllCards() {
        
        //given
        //when
        
        let expectation = self.expectation(description: "add card")
        
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { cards in
                XCTAssertTrue(cards.isEmpty)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.deleteAllCards()

        waitForExpectations(timeout: 1)

    }
}

class MockListService: CardListServiceProtocol {
    var delete = false
    var cards = [
        CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Juan Perez"),
        CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "MasterCard", cardHolderName: "Juan Perez"),
        CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Bank", cardHolderName: "Juan Perez")
    ]
    
    func deleteAllCreditCardsFromSecureStore() -> Future<CardFortress.SecureStoreResult, Error> {
        delete = true
        return Future { promise in
            promise(.success(.success))
        }
    }
    

    func addCreditCardToSecureStore(_ creditCard: CardFortress.CreditCard) -> Future<CardFortress.SecureStoreResult, Error> {
        Future { [unowned self] promise in
            cards.append(creditCard)
            promise(.success(.success))
        }
    }

    func getCreditCardsFromSecureStore() -> Future<[CreditCard], Error> {
        
        return Future { [unowned self] promise in
            delete ? promise(.success([])) :promise(.success(cards))
        }
    }
}
