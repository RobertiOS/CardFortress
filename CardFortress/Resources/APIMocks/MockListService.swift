//
//  MockListService.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/6/23.
//

import Combine
import Foundation

final class MockListService: CardListServiceProtocol {
    var delete = false
    var cards = [
        CreditCard(number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Roberto"),
        CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "MasterCard", cardHolderName: "Carlos Perez"),
        CreditCard(number: 1223, cvv: 1223, date: "1123", cardName: "Bank", cardHolderName: "Juan Perez")
    ]
    
    func deleteAllCreditCardsFromSecureStore() -> Future<CardListServiceResult, Error> {
        delete = true
        return Future { promise in
            promise(.success(.success))
        }
    }
    

    func addCreditCardToSecureStore(_ creditCard: CardFortress.CreditCard) -> Future<CardListServiceResult, Error> {
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
