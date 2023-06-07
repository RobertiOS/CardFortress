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
        Future { [weak self] promise in
            guard let self else { return }
            Task(priority: .userInitiated) {
                do {
                    let secureStoreCD: SecureStoreCreditCard = .init(creditCard: creditCard)
                    let result = try await self.secureStore.addCreditCardToKeychain(secureStoreCD)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

    func getCreditCardsFromSecureStore() -> Future<[CreditCard], Error> {
        Future { promise in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    let creditCards: [CreditCard] = try await self.secureStore.getAllCreditCardsFromKeychain().map {
                        .init(creditCard: $0)
                    }
                    promise(.success(creditCards))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

    func deleteAllCreditCardsFromSecureStore() -> Future<SecureStoreResult, Error> {
        Future { promise in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    let result = try await self.secureStore.removeAllCreditCards()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

}
