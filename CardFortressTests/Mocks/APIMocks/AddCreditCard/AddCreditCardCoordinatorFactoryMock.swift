//
//  AddCreditCardCoordinatorFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit
import Domain

final class AddCreditCardCoordinatorFactoryMock: AddCreditCardCoordinatorFactoryProtocol {
    
    var visionKitCoordinatorMock: VisionKitCoordinator?
    
    func makeAddCreditCardCoordinator(tabBarItem: UITabBarItem) -> AddCreditCardCoordinator {
        AddCreditCardCoordinator(navigationController: UINavigationController(), factory: AddCreditCardViewControllerFactoryMock(), coordinatorFactory: self)
    }
    
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        visionKitCoordinatorMock = VisionKitCoordinator(factory: AddCreditCardViewControllerFactoryMock(), navigationController: navigationController)
        return visionKitCoordinatorMock!
    }
    
    func makeEditCreditCardCoordinator(creditCard: DomainCreditCard, navigationController: UINavigationController) -> AddCreditCardCoordinator {
        AddCreditCardCoordinator(navigationController: navigationController, factory: AddCreditCardViewControllerFactoryMock(), coordinatorFactory: self, action: .editCreditCard(creditCard))
    }
}
