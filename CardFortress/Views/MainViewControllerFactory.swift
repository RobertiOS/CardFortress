//
//  MainViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/14/23.
//

import UIKit
import Swinject
import VisionKit

protocol CreditCardListFactoryProtocol: AnyObject {
    func makeMainListViewController() -> CardListViewControllerProtocol
}

protocol AddCreditCardFactoryProtocol: AnyObject {
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol
}

protocol VisionKitFactoryProtocol: AnyObject {
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
}


final class MainViewControllerFactory: CreditCardListFactoryProtocol,
                                       AddCreditCardFactoryProtocol,
                                       VisionKitFactoryProtocol {
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
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewController()
    }
}
