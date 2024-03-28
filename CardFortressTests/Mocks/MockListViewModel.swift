//
//  MockListViewModel.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/6/23.
//

@testable import CardFortress
import Combine
import Foundation
import Domain

final class MockListViewModel: ListViewModelProtocol {
    
   
    
    let isLoadingSubject = PassthroughSubject<Bool, Never>()
    let itemsSubject = PassthroughSubject<[DomainCreditCard], Error>()
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    var itemsPublisher: AnyPublisher<[DomainCreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }
    
    var deleteCardsCalled = false
    func deleteAllCards() {
        deleteCardsCalled = true
        itemsSubject.send([])
    }
    
    func deleteCreditCard(_ creditCardIdentifier: UUID) {
    }
    
    var cards: [DomainCreditCard] = [] {
        didSet {
            itemsSubject.send(cards)
        }
    }
    func addCreditCard(_ creditCard: DomainCreditCard) {
        cards.append(creditCard)
    }

    
    func fetchCreditCards() {
        
        itemsSubject.send(cards)
    }
}
