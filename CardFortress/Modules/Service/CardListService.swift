//
//  CardListService.swift
//  CardFortress
//
//  Created by Roberto Corrales on 29/04/23.
//

import Foundation
import Combine

protocol CardListServiceProtocol {
    func getCreditCardsFromSecureStore() -> Future<[CreditCard], Error>
    func addCreditCardToSecureStore(_ creditCard: CreditCard) -> Future<SecureStoreResult, Error>
    func deleteAllCreditCardsFromSecureStore() -> Future<SecureStoreResult, Error>
}


final class CardListService: CardListServiceProtocol {

    private let secureStore: SecureStoreProtocol

    init(secureStore: SecureStoreProtocol) {
        self.secureStore = secureStore
    }
    
    func addCreditCardToSecureStore(_ creditCard: CreditCard) -> Future<SecureStoreResult, Error> {
        secureStore.addCreditCardToKeychain(creditCard)
    }

    func getCreditCardsFromSecureStore() -> Future<[CreditCard], Error> {
        secureStore.getAllCreditCardsFromKeychain()
    }

    func deleteAllCreditCardsFromSecureStore() -> Future<SecureStoreResult, Error> {
        secureStore.removeAllCreditCards()
    }

}
