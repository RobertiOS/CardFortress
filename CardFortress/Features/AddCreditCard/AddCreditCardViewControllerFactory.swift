//
//  AddCreditCardViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Swinject
import Domain

protocol AddCreditCardViewControllerFactoryProtocol {
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewController
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
}

final class AddCreditCardViewControllerFactory: AddCreditCardViewControllerFactoryProtocol {
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
    }
    
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewController {
        
        guard let addCreditCardsUseCaseProtocol = container.resolve(AddCreditCardsUseCaseProtocol.self) else { preconditionFailure("Use cases not registered on the container") }
        
        let viewModel = AddCreditCardViewController.ViewModel(addCreditCardUseCase: addCreditCardsUseCaseProtocol, action: action)
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewController()
    }
}
