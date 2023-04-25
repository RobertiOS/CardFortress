//
//  ListViewModelProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation
import Combine

protocol ListViewModelProtocol {
    var itemsPublisher: AnyPublisher<[String], Never> { get }
    func fetchItems()
    func updateItems(_ items: [String])
}

final class ListViewModel: ListViewModelProtocol {
    
    private let items = ["Tarjeta 1", "Tarjeta 2", "Tarjeta 3", "Tarjeta 4", "Tarjeta 5", "Tarjeta 6", "Tarjeta 7", "Tarjeta 8", "Tarjeta 9", "Tarjeta 10"]
    private let itemsSubject = CurrentValueSubject<[String], Never>([])

    var itemsPublisher: AnyPublisher<[String], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    func fetchItems() {
        itemsSubject.send(items)
    }

    func updateItems(_ items: [String]) {
        itemsSubject.send(items)
    }
}

