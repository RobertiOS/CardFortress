//
//  ListViewModelProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation
import Combine

protocol ListViewModelProtocol: AnyObject {
    var itemsPublisher: AnyPublisher<[String], Never> { get }
    func fetchItems()
    func updateItems(_ items: [String])
    var cardListService: CardListServiceProtocol { get set }
}

final class ListViewModel: ListViewModelProtocol {
    private var subscriptions = Set<AnyCancellable>()
    
    init(cardListService: CardListServiceProtocol = CardListService()) {
        self.cardListService = cardListService
    }

    var cardListService: CardListServiceProtocol
    
    private let itemsSubject = PassthroughSubject<[String], Never>()

    var itemsPublisher: AnyPublisher<[String], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchItems() {
        cardListService.getCards()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // no op
            } receiveValue: { [weak self] cards in
                self?.itemsSubject.send(cards)
            }
            .store(in: &subscriptions)
    }

    func updateItems(_ items: [String]) {
        itemsSubject.send(items)
    }
}

