//
//  CardFortressRootCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit

final class CardFortressRootCoordinator: Coordinator {

    // MARK: properties
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: actions
    
    func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        children.append(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
    }
}
