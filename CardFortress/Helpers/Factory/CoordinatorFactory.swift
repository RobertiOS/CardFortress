//
//  CoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/4/23.
//

import UIKit
import Swinject

protocol MainListCoordinatorFactory {
    func makeMainListCoordinator() -> TabBarCoordinatorProtocol
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol
}

final class CoordinatorFactory: MainListCoordinatorFactory {
    
    private let container: Container
    private let viewControllerFactory: MainViewControllerFactory
    
    init(container: Container,
         viewControllerFactory: MainViewControllerFactory) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
    }
    
    //MARK: - MainListCoordinatorFactory
    
    func makeMainListCoordinator() -> TabBarCoordinatorProtocol {
        let tabBarItem: UITabBarItem = .init(tabBarIndex: .main)
        let navigationController = makeNavigationController(tabBarItem: tabBarItem)
        let mainCoordinator = CardListCoordinator(
            container: container,
            viewControllerFactory: viewControllerFactory,
            navigationController: navigationController)
        return mainCoordinator
    }
    
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol {
        let tabBarItem: UITabBarItem = .init(tabBarIndex: .add)
        let navigationController = makeNavigationController(tabBarItem: tabBarItem)
        let coordinator = AddCreditCardCoordinator(navigationController: navigationController,
                                                   containter: container,
                                                   factory: viewControllerFactory)
        return coordinator
    }
    
    private func makeNavigationController(tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .systemBackground
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
}
