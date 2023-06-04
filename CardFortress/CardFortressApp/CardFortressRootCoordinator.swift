//
//  CardFortressRootCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

enum CardFortressResultCoordinator {
    case success
}

final class CardFortressRootCoordinator: Coordinator<CardFortressResultCoordinator> {

    // MARK: properties
    private let window: UIWindow
    private let container: Container
    private let navigationController: UINavigationController
    private let viewControllerFactory: RootVCFactoryProtocol
    private let coordinatorFactory: CoordinatorFactory
    
    // MARK: initialization
    
    convenience init(window: UIWindow,
                     container: Container) {
        self.init(
            window: window,
            container: container,
            coordinatorFactory: CoordinatorFactory(container: container),
            viewControllerFactory: RootVCFactory()
        )
    }
    
    init(window: UIWindow,
         container: Container,
         coordinatorFactory: CoordinatorFactory,
         viewControllerFactory: RootVCFactoryProtocol) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = viewControllerFactory.makeNavigationController()
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        window.rootViewController = navigationController
    }
    
    // MARK: actions
    
    override func start() {
        let mainCoordinator = coordinatorFactory.makeMainListCoordinator(navigationController: navigationController)
        mainCoordinator.start()
    }
}
