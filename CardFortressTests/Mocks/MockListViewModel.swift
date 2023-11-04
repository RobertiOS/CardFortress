//
//  MockListViewModel.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/6/23.
//

@testable import CardFortress
import Combine
import Foundation

final class MockListViewModel: ListViewModelProtocol {
    func deleteAllCards() {
        itemsSubject.send([])
    }
    
    var cards: [CreditCard] = [] {
        didSet {
            itemsSubject.send(cards)
        }
    }
    func addCreditCard(_ creditCard: CardFortress.CreditCard) {
        cards.append(creditCard)
    }

    var cardListService: CardFortress.CardListServiceProtocol
    
    init(cardListService: CardFortress.CardListServiceProtocol) {
        self.cardListService = cardListService
    }

    let itemsSubject = PassthroughSubject<[CreditCard], Error>()

    var itemsPublisher: AnyPublisher<[CreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchCreditCards() {
        
        itemsSubject.send(cards)
    }
}
