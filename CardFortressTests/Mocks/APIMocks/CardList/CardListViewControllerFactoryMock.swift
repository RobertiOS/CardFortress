//
//  CardListViewControllerFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import Foundation
import MockSupport

final class CardListViewControllerFactoryMock: CardListViewControllerFactoryProtocol {
    func makeMainListViewController<T>(delegate: T) -> CardListViewController where T : CardListViewControllerDelegate {
        CardListViewController(viewModel: ListViewModel(getCreditCardsUseCase: GetCreditCardsUseCaseMock(), removeCreditCardUseCase: RemoveCreditCardUseCaseMock()))
    }
}

