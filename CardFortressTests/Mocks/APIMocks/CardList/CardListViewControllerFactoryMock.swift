//
//  CardListViewControllerFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import Foundation

final class CardListViewControllerFactoryMock: CardListViewControllerFactoryProtocol {
    func makeMainListViewController<T>(delegate: T) -> CardListViewController where T : CardListViewControllerDelegate {
        CardListViewController(viewModel: ListViewModel(cardListService: MockListService()))
    }
}

