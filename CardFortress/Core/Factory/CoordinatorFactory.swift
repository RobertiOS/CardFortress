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
    func makeTabBarCoordinator(window: UIWindow?) -> TabBarCoordinator
}

protocol LoginCoordinatorFactory {
    func makeAuthCoordinator(window: UIWindow?) -> AuthCoordinating
}

protocol VisionKitCoordinatorFactory {
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating
}

protocol EditCreditCardCoodinatorFactory {
    func makeEditCreditCardCoordinator(
        creditCard: CreditCard,
        navigationController: UINavigationController
    ) -> AddCreditCardCoordinator
}

class CoordinatorFactory:
    TabBarCoordinatorFactory,
    AppCoordinatorFactory,
    LoginCoordinatorFactory,
    VisionKitCoordinatorFactory,
    EditCreditCardCoodinatorFactory {
    
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
            navigationController: navigationController,
            coordinatorFactory: self)
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
    
    func makeTabBarCoordinator(window: UIWindow?) -> TabBarCoordinator {
        TabBarCoordinator(
            coordinatorFactory: self,
            window: window,
            container: container
        )
    }
    
    //MARK: - LoginCoordinatorFactory
    
    func makeAuthCoordinator(window: UIWindow?) -> AuthCoordinating {
        let authenticationAPI = container.resolve(AuthenticationAPI.self)
        let secureUserDataAPI = container.resolve(SecureUserDataAPI.self)
        return AuthCoordinator(
            factory: viewControllerFactory,
            authenticationAPI: authenticationAPI,
            secureUserDataAPI: secureUserDataAPI,
            window: window
        )
    }
    
    //MARK: - Vision kit factory
    
    func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        VisionKitCoordinator(factory: viewControllerFactory, navigationController: navigationController)
    }
    
    // MARK: - Edit credit card factory
    
    func makeEditCreditCardCoordinator(
        creditCard: CreditCard,
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
