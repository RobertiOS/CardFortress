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
    private let rootFactory: CardFordtressRootFactoryProtocol
    
    // MARK: initialization
    
    convenience init(window: UIWindow,
                     container: Container) {
        self.init(window: window,
                  container: container,
                  rootfactory: CardFordtressRootFactory(container: container))
    }
    
    init(window: UIWindow,
         container: Container,
         rootfactory: CardFordtressRootFactoryProtocol) {
        self.container = container
        self.rootFactory = rootfactory
        navigationController = rootfactory.makeNavigationController()
        self.window = window
        window.rootViewController = navigationController
    }
    
    // MARK: actions
    
    override func start() {
        let mainListFactory = rootFactory.makeMainListFactory()
        let mainCoordinator = MainCoordinator(
            container: container,
            viewControllerFactory: mainListFactory,
            navigationController: navigationController)
        addChild(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
}
