//
//  CardFortressTabBarCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

final class CardFortressAppCoordinator: Coordinator<Void> {

    // MARK: properties
    private let window: UIWindow?
    private let container: Container
    private let coordinatorFactory: CoordinatorFactory
    private let navigationController: UINavigationController

    // MARK: initialization
    
    convenience init(window: UIWindow?,
                     container: Container,
                     coordinatorFactory: CoordinatorFactory? = nil,
                     viewControllerFactory: MainViewControllerFactory? = nil) {
        self.init(
            window: window,
            container: container,
            coordinatorFactory: coordinatorFactory ?? CoordinatorFactory(
                container: container,
                viewControllerFactory: viewControllerFactory ?? MainViewControllerFactory(container: container)
            )
        )
    }
    
    init(window: UIWindow?,
         container: Container,
         coordinatorFactory: CoordinatorFactory) {
        self.container = container
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        navigationController = MainViewControllerFactory(container: container).makeNavigationController()
        navigationController.isNavigationBarHidden = true
        super.init()
    }
    
    // MARK: Methods
    
    override func start() {
        ///start login coordinator
        let authAPI = container.resolve(AuthenticationAPI.self)
        
        if authAPI?.isUserLoggedIn ?? false {
            startTabBarCoordinator()
        } else {
            startLoginCoordinator()
        }
    }
    
    func startTabBarCoordinator() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(window: window)
        addChild(coordinator: coordinator)

        coordinator.onFinish = { [weak self] result in
            switch result {
            case .signOut:
                self?.startLoginCoordinator()
            }
        }

        coordinator.start()
    }

    func startLoginCoordinator() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(window: window)
        addChild(coordinator: coordinator)
        
        coordinator.onFinish = { [weak self] result in
            switch result {
            case .success:
                self?.startTabBarCoordinator()
            case .failure(_):
                return
            }
        }
        coordinator.start()
    }
}


