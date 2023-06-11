//
//  AddCreditCardCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/10/23.
//

import UIKit
import Swinject

final class AddCreditCardCoordinator: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    private let containter: Container
    private let factory: AddCreditCardFactoryProtocol
    
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController,
         containter: Container,
         factory: AddCreditCardFactoryProtocol) {
        self.navigationController = navigationController
        self.containter = containter
        self.factory = factory
    }
    
    override func start() {
        guard let viewController = factory.makeAddCardViewController() as? AddCreditCardViewController else {
            preconditionFailure()
        }
        navigateTo(viewController, presentationStyle: .push)
    }
    
}
