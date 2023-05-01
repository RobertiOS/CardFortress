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
    }
    
    func getCards() -> Future<[CreditCard], Error> {
        secureStore.getAllCreditCardsFromKeychain()
    }
    
    func saveCart() {
        // No operation
    }
    
    
}
