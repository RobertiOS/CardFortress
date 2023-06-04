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

    private let secureStorePOC: SecureStoreProtocolPOC

    init(secureStorePOC: SecureStoreProtocolPOC) {
        self.secureStorePOC = secureStorePOC
    }
    
    func addCreditCardToSecureStore(_ creditCard: CreditCard) -> Future<SecureStoreResult, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task(priority: .userInitiated) {
                do {
                    let secureStoreCD: SecureStoreCreditCard = .init(creditCard: creditCard)
                    let result = try await self.secureStorePOC.addCreditCardToKeychain(secureStoreCD)
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
                    let creditCards: [CreditCard] = try await self.secureStorePOC.getAllCreditCardsFromKeychain().map {
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
                    let result = try await self.secureStorePOC.removeAllCreditCards()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

}
