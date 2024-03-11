//
//  AddCreditCardCoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import UIKit
import CFDomain

protocol AddCreditCardCoordinatorFactoryProtocol {
    func makeAddCreditCardCoordinator(
        tabBarItem: UITabBarItem
    ) -> AddCreditCardCoordinator
    func makeVisionKitCoordinator(
        navigationController: UINavigationController
    ) -> VisionKitCoordinating
    func makeEditCreditCardCoordinator(
        creditCard: DomainCreditCard,
        navigationController: UINavigationController
    ) -> AddCreditCardCoordinator
}

final class AddCreditCardCoordinatorFactory: AddCreditCardCoordinatorFactoryProtocol {
    internal init(viewControllerFactory: AddCreditCardViewControllerFactoryProtocol) {
        self.viewControllerFactory = viewControllerFactory
    }
    
    private let viewControllerFactory: AddCreditCardViewControllerFactoryProtocol
    
    
    func makeAddCreditCardCoordinator(tabBarItem: UITabBarItem) -> AddCreditCardCoordinator {
        let navigationController = UINavigationController.makeNavigationController(tabBarItem: tabBarItem)
        let coordinator = AddCreditCardCoordinator(navigationController: navigationController,
                                                   factory: viewControllerFactory,
                                                   coordinatorFactory: self)
        return coordinator
    }
    
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        VisionKitCoordinator(factory: viewControllerFactory, navigationController: navigationController)
    }
    
    func makeEditCreditCardCoordinator(
        creditCard: DomainCreditCard,
        navigationController: UINavigationController
    ) -> AddCreditCardCoordinator {
        let coordinator = AddCreditCardCoordinator(
            navigationController: navigationController,
            factory: viewControllerFactory,
            coordinatorFactory: self,
            action: .editCreditCard(creditCard)
        )
        return coordinator
    }
}
