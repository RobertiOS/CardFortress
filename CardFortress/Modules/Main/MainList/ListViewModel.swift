//
//  ListViewModelProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation
import Combine

protocol ListViewModelProtocol: AnyObject {
    var itemsPublisher: AnyPublisher<[CreditCard], Error> { get }
    func fetchItems()
    func updateItems(_ items: [CreditCard])
    var cardListService: CardListServiceProtocol { get set }
}

final class ListViewModel: ListViewModelProtocol {
    private var subscriptions = Set<AnyCancellable>()
    
    init(cardListService: CardListServiceProtocol = CardListService()) {
        self.cardListService = cardListService
    }

    var cardListService: CardListServiceProtocol
    
    private let itemsSubject = PassthroughSubject<[CreditCard], Error>()

    var itemsPublisher: AnyPublisher<[CreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchItems() {
        cardListService.getCards()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.itemsSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] cards in
                self?.itemsSubject.send(cards)
            }
            .store(in: &subscriptions)
    }

    func updateItems(_ items: [CreditCard]) {
        itemsSubject.send(items)
    }
}

