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
        let cardData : [String : Any] = [
            "identifier": creditCard.identifier.uuidString,
            "number": creditCard.number,
            "cvv": creditCard.cvv,
            "date": creditCard.date,
            "cardName": creditCard.cardName,
            "cardHolderName": creditCard.cardHolderName
        ]
        return Future { [weak self] promise in
            guard let self else { return }
            Task(priority: .userInitiated) {
                do {
                    let encodedCard = try self.secureStorePOC.createEncodedCreditCard(for: cardData)
                    let result = try await self.secureStorePOC.addCreditCardToKeychain(encodedCard)
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
                    let cardData = try await self.secureStorePOC.getAllCreditCardsFromKeychain()
                    let jsonDecoder = JSONDecoder()
                    let cards = cardData.compactMap {
                        do {
                            let card = try jsonDecoder.decode(CreditCard.self, from: $0)
                            return card
                        } catch {
                            promise(.failure(error))
                            return nil
                        }
                    }
                    promise(.success(cards))
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
