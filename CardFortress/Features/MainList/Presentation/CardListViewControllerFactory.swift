//
//  CardListViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Domain
import Swinject

protocol CardListViewControllerFactoryProtocol {
    func makeMainListViewController<T: CardListViewControllerDelegate>(delegate: T) -> CardListViewController
}

final class CardListViewControllerFactory: CardListViewControllerFactoryProtocol {
    
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
    }
    
    func makeMainListViewController<T: CardListViewControllerDelegate>(
        delegate: T
    ) -> CardListViewController {
        guard let getCreditCardsUseCase = container.resolve(GetCreditCardsUseCaseProtocol.self),
              let removeCreditCardsUseCase = container.resolve(RemoveCreditCardUseCaseProtocol.self) else {
            preconditionFailure(
                "Use Cases not registered"
            )
        }
        let listViewModel = ListViewModel(
            getCreditCardsUseCase: getCreditCardsUseCase,
            removeCreditCardUseCase: removeCreditCardsUseCase
        )
        let viewcontroller = CardListViewController(
            viewModel: listViewModel
        )
        viewcontroller.delegate = delegate
        return viewcontroller
        
    }
}
