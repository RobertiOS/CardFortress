//
//  CardListService.swift
//  CardFortress
//
//  Created by Roberto Corrales on 29/04/23.
//

import Foundation
import Combine

protocol CardListServiceProtocol {
    func getCards() -> Future<[CreditCard], Error>
    func saveCart()
}


final class CardListService: CardListServiceProtocol {
    private let secureStore: SecureStoreProtocol
    init(secureStore: SecureStoreProtocol = SecureStore(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))) {
        self.secureStore = secureStore
        _ = secureStore.removeAllCreditCards()
        let creditCards = [
            CreditCard(number: 1111333322224444, cvv: 123, date: "11/12/12", cardName: "Bank of America", cardHolderName: "Roberto Corrales"),
            CreditCard(number: 1111333322224444, cvv: 123, date: "11/12/12", cardName: "Bank 2", cardHolderName: "Roberto Corrales"),
            CreditCard(number: 1111333322224444, cvv: 123, date: "11/12/12", cardName: "Bank 3", cardHolderName: "Roberto Corrales"),
        ]
        
        creditCards.forEach { creditCard in
            try! secureStore.saveCreditCardDataToKeychain(card: creditCard)
        }
    }
    
    func getCards() -> Future<[CreditCard], Error> {
        secureStore.getAllCreditCardsFromKeychain()
    }
    
    func saveCart() {
        // No operation
    }
    
    
}
