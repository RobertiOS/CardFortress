//
//  MainViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/14/23.
//

import UIKit
import Swinject

protocol CreditCardListFactoryProtocol: AnyObject {
    func makeMainListViewController() -> CardListViewControllerProtocol
}

protocol AddCreditCardFactoryProtocol: AnyObject {
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol
}


final class MainViewControllerFactory: CreditCardListFactoryProtocol, AddCreditCardFactoryProtocol {
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func makeMainListViewController() -> CardListViewControllerProtocol {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let listViewModel = ListViewModel(cardListService: service)
        let viewcontroller = CardListViewController(viewModel: listViewModel)
        return viewcontroller
        
    }
    
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let viewModel = AddCreditCardViewController.ViewModel(service: service)
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        viewController.title = "Add credit card"
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
}
