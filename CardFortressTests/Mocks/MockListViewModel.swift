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
    let isLoadingSubject = PassthroughSubject<Bool, Never>()
    let itemsSubject = PassthroughSubject<[CreditCard], Error>()
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    var itemsPublisher: AnyPublisher<[CreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }
    
    var deleteCardsCalled = false
    func deleteAllCards() {
        deleteCardsCalled = true
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

    var cardListService: CardListServiceProtocol = MockListService()
    
    func fetchCreditCards() {
        
        itemsSubject.send(cards)
    }
}
