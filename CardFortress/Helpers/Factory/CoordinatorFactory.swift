//
//  CoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/4/23.
//

import UIKit
import Swinject

protocol TabBarCoordinatorFactory {
    func makeMainListCoordinator() -> TabBarCoordinatorProtocol
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol
}

protocol AppCoordinatorFactory {
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator
}

protocol LoginCoordinatorFactory {
    func makeLoginCoordinator(navigationController: UINavigationController) -> LoginCoordinator
}

final class CoordinatorFactory:
    TabBarCoordinatorFactory,
    AppCoordinatorFactory,
    LoginCoordinatorFactory {
    
    private let container: Container
    private let viewControllerFactory: MainViewControllerFactory
    
    init(container: Container,
         viewControllerFactory: MainViewControllerFactory) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
    }
    
    //MARK: - TabBarCoordinatorFactory
    
    func makeMainListCoordinator() -> TabBarCoordinatorProtocol {
        let tabBarItem: UITabBarItem = .init(tabBarIndex: .main)
        let navigationController = viewControllerFactory.makeNavigationController(tabBarItem: tabBarItem)
        let mainCoordinator = CardListCoordinator(
            container: container,
            viewControllerFactory: viewControllerFactory,
            navigationController: navigationController)
        return mainCoordinator
    }
    
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol {
        let tabBarItem: UITabBarItem = .init(tabBarIndex: .add)
        let navigationController = viewControllerFactory.makeNavigationController(tabBarItem: tabBarItem)
        let coordinator = AddCreditCardCoordinator(navigationController: navigationController,
                                                   containter: container,
                                                   factory: viewControllerFactory)
        return coordinator
    }
    
    //MARK: - AppCoordinatorFactory
    
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        TabBarCoordinator(
            coordinatorFactory: self,
            navigationController: navigationController
        )
    }
    
    //MARK: - LoginCoordinatorFactory
    
    func makeLoginCoordinator(navigationController: UINavigationController) -> LoginCoordinator {
        let authenticationAPI = container.resolve(AuthenticationAPI.self)
        return LoginCoordinator(
            factory: viewControllerFactory,
            navigationController: navigationController,
            authenticationAPI: authenticationAPI
        )
    }
    
}
