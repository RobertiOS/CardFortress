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
                     container: Container) {
        self.init(
            window: window,
            container: container,
            coordinatorFactory: CoordinatorFactory(
                container: container,
                viewControllerFactory: MainViewControllerFactory(container: container)
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
        window?.rootViewController = navigationController
    }
    
    // MARK: Methods
    
    override func start() {
        ///start login coordinator
        startLoginCoordinator()
        
    }
    
    func startTabBarCoordinator() {
        
        let coordinator = coordinatorFactory.makeTabBarCoordinator(navigationController: navigationController)
        addChild(coordinator: coordinator)
        coordinator.start()
    }

    func startLoginCoordinator() {
        let coordinator = coordinatorFactory.makeLoginCoordinator(navigationController: navigationController)
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

extension CardFortressAppCoordinator {
    
    var testHooks: TestHooks {
        .init(target: self)
    }
    
    struct TestHooks {
        let target: CardFortressAppCoordinator
        
        init(target: CardFortressAppCoordinator) {
            self.target = target
        }
    }
    
}


