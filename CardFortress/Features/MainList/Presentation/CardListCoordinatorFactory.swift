//
//  CardListCoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import UIKit
import Swinject

protocol CardListCoordinatorFactoryProtocol {
    func makeMainListCoordinator(tabBarItem: UITabBarItem) -> CardListCoordinating
}

final class CardListCoordinatorFactory: CardListCoordinatorFactoryProtocol {
    
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
    }
    
    func makeMainListCoordinator(tabBarItem: UITabBarItem) -> CardListCoordinating {
        let tabBarItem: UITabBarItem = .init(tabBarIndex: .main)
        let navigationController = UINavigationController.makeNavigationController(tabBarItem: tabBarItem)
        let mainCoordinator = CardListCoordinator(
            viewControllerFactory: CardListViewControllerFactory(container: container),
            navigationController: navigationController,
            container: container)
        return mainCoordinator
    }
}
