//
//  CardFortressRootCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

final class CardFortressRootCoordinator: Coordinator {

    // MARK: properties
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let container: Container
    
    // MARK: initialization
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: actions
    
    func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, container: container)
        children.append(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
    }
}
