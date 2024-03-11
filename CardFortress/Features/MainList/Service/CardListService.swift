//
//  CardListService.swift
//  CardFortress
//
//  Created by Roberto Corrales on 29/04/23.
//

import Foundation
import Combine
import CFAPIs

protocol CardListServiceProtocol {
    func getCreditCardsFromSecureStore() -> Future<[CreditCard], Error>
    func addCreditCardToSecureStore(_ creditCard: CreditCard) -> Future<CardListServiceResult, Error>
    func deleteAllCreditCardsFromSecureStore() -> Future<CardListServiceResult, Error>
    func deleteCreditCardFromSecureStore(creditCardIdenfitifer: UUID) -> Future<[CreditCard], Error>
}

enum CardListServiceResult {
    case success
    case failure(Error)
    case addSuccess
    case editSuccess
    
    init(secureStoreResult: SecureStoreResult) {
        switch secureStoreResult {
        case .success:
            self = .success
        case .failure(let secureStoreFailure):
            self = .failure(secureStoreFailure)
        case .editSuccess:
            self = .editSuccess
        case .addSuccess:
            self = .addSuccess
        }
    }
}


final class CardListService: CardListServiceProtocol {

    private let secureStore: CreditCardRepository
    
    private var subscriptions = Set<AnyCancellable>()

    init(secureStore: CreditCardRepository) {
        self.secureStore = secureStore
    }
    
    func addCreditCardToSecureStore(_ creditCard: CreditCard) -> Future<CardListServiceResult, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task(priority: .userInitiated) {
                do {
                    let secureStoreCD: SecureStoreCreditCard = .init(creditCard: creditCard)
                    try await self.secureStore.addCreditCard(
                        .init(
                            identifier: secureStoreCD.identifier,
                            number: secureStoreCD.number,
                            cvv: secureStoreCD.cvv,
                            date: secureStoreCD.date,
                            cardName: secureStoreCD.cardName,
                            cardHolderName: secureStoreCD.cardHolderName,
                            notes: "",
                            isFavorite: false
                        )
                    )
                    promise(.success(.addSuccess))
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
                    let creditCards: [CreditCard] = try await self.secureStore.getAllCreditCards().map {
                        .init(
                            identifier: $0.identifier,
                            number: $0.number,
                            cvv: $0.cvv,
                            date: $0.date,
                            cardName: $0.cardName,
                            cardHolderName: $0.cardHolderName
                        )
                    }
                    promise(.success(creditCards))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

    func deleteAllCreditCardsFromSecureStore() -> Future<CardListServiceResult, Error> {
        Future { promise in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    try await self.secureStore.removeAllCreditCards()
                    promise(.success(.addSuccess))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    func deleteCreditCardFromSecureStore(creditCardIdenfitifer: UUID) -> Future<[CreditCard], Error> {
        Future { promise in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    try await self.secureStore.removeCreditCard(id: creditCardIdenfitifer)
                    getCreditCardsFromSecureStore().sink(receiveCompletion: { _ in }) { reditCards in
                        promise(.success(creditCards))
                    }.store(in: &subscriptions)
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

}
