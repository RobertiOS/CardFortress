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

final class CardFortressRootCoordinator: Coordinator<CardFortressResultCoordinator>, NavigationCoordinator {

    // MARK: properties
    private let window: UIWindow
    private let container: Container
    var navigationController: UINavigationController
    
    // MARK: initialization
    
    init(window: UIWindow, container: Container) {
        self.container = container
        navigationController = container.resolve(UINavigationController.self) ?? UINavigationController()
        self.window = window
        window.rootViewController = navigationController
    }
    
    // MARK: actions
    
    override func start() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, container: container)
        mainCoordinator.onFinish = { result in
            
        }
        addChild(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
}
