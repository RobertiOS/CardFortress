//
//  CoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/4/23.
//

import UIKit
import Swinject

protocol MainListCoordinatorFactory {
    func makeMainListCoordinator(navigationController: UINavigationController) -> Coordinator<MainCoordinatorResult>
}

final class CoordinatorFactory: MainListCoordinatorFactory {
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    //MARK: - MainListCoordinatorFactory
    
    func makeMainListCoordinator(navigationController: UINavigationController) -> Coordinator<MainCoordinatorResult> {
        let mainFactory = MainListFactory(container: container)
        let mainCoordinator = MainCoordinator(
            container: container,
            viewControllerFactory: mainFactory,
            navigationController: navigationController)
        return mainCoordinator
    }
}
