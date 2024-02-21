//
//  CardListViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Swinject

protocol CardListViewControllerFactoryProtocol {
    func makeMainListViewController<T: CardListViewControllerDelegate>(delegate: T) -> CardListViewController
}

final class CardListViewControllerFactory: CardListViewControllerFactoryProtocol {
    
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
    }
    
    func makeMainListViewController<T: CardListViewControllerDelegate>(delegate: T) -> CardListViewController {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let listViewModel = ListViewModel(cardListService: service)
        let viewcontroller = CardListViewController(viewModel: listViewModel)
        viewcontroller.delegate = delegate
        return viewcontroller
        
    }
}
