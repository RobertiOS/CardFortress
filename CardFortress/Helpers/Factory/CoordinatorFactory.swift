//
//  CoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/4/23.
//

import UIKit
import Swinject

protocol TabBarCoordinatorFactory {
    func makeMainListCoordinator() -> CardListCoordinating
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol
}

protocol AppCoordinatorFactory {
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator
}

protocol LoginCoordinatorFactory {
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating
}

protocol VisionKitCoordinatorFactory {
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating
}

class CoordinatorFactory:
    TabBarCoordinatorFactory,
    AppCoordinatorFactory,
    LoginCoordinatorFactory,
    VisionKitCoordinatorFactory {
    
    private let container: Container
    private let viewControllerFactory: MainViewControllerFactory
    
    init(container: Container,
         viewControllerFactory: MainViewControllerFactory) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
    }
    
    //MARK: - TabBarCoordinatorFactory
    
    func makeMainListCoordinator() -> CardListCoordinating {
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
                                                   factory: viewControllerFactory,
                                                   coordinatorFactory: self)
        return coordinator
    }
    
    //MARK: - AppCoordinatorFactory
    
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        TabBarCoordinator(
            coordinatorFactory: self,
            navigationController: navigationController,
            container: container
        )
    }
    
    //MARK: - LoginCoordinatorFactory
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating {
        let authenticationAPI = container.resolve(AuthenticationAPI.self)
        return AuthCoordinator(
            factory: viewControllerFactory,
            navigationController: navigationController,
            authenticationAPI: authenticationAPI
        )
    }
    
    //MARK: - Vision kit factory
    
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        VisionKitCoordinator(factory: viewControllerFactory, navigationController: navigationController)
    }
}
