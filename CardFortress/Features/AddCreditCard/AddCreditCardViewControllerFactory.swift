//
//  AddCreditCardViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Swinject

protocol AddCreditCardViewControllerFactoryProtocol {
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewController
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
}

final class AddCreditCardViewControllerFactory: AddCreditCardViewControllerFactoryProtocol {
    private let service: CardListServiceProtocol
    
    internal init(service: CardListServiceProtocol) {
        self.service = service
    }
    
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewController {
        let viewModel = AddCreditCardViewController.ViewModel(service: service, action: action)
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewController()
    }
}
