//
//  MainListFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/14/23.
//

import UIKit
import Swinject

protocol MainListFactoryProtocol {
    func makeMainListViewController() -> CardListViewController
}

final class MainListFactory: MainListFactoryProtocol {
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func makeMainListViewController() -> CardListViewController {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let listViewModel = ListViewModel(cardListService: service)
        let viewcontroller = CardListViewController(viewModel: listViewModel)
        return viewcontroller
        
    }
}
