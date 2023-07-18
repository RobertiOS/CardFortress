//
//  CardListCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject


enum MainCoordinatorResult {
    case success
}

final class CardListCoordinator: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    //MARK: properties
    var navigationController: UINavigationController
    private let viewControllerFactory: CreditCardListFactoryProtocol
    private let container: Container
    
    //MARK: initialization
    init(container: Container,
         viewControllerFactory: CreditCardListFactoryProtocol,
         navigationController: UINavigationController) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = viewControllerFactory.makeMainListViewController()
        navigateTo(viewController, presentationStyle: .push)
    }
}
