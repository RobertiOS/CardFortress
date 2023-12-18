//
//  AddCreditCardCoordinatorFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit

final class AddCreditCardCoordinatorFactoryMock: AddCreditCardCoordinatorFactoryProtocol {
    func makeAddCreditCardCoordinator(tabBarItem: UITabBarItem) -> AddCreditCardCoordinator {
        AddCreditCardCoordinator(navigationController: UINavigationController(), factory: AddCreditCardViewControllerFactoryMock(), coordinatorFactory: self)
    }
    
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        VisionKitCoordinator(factory: AddCreditCardViewControllerFactoryMock(), navigationController: UINavigationController())
    }
    
    func makeEditCreditCardCoordinator(creditCard: CreditCard, navigationController: UINavigationController) -> AddCreditCardCoordinator {
        AddCreditCardCoordinator(navigationController: UINavigationController(), factory: AddCreditCardViewControllerFactoryMock(), coordinatorFactory: self, action: .editCreditCard(creditCard))
    }
}
