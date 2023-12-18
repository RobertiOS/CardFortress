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
    private let coordinatorFactory: CardFortressCoordinatorFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?

    // MARK: initialization
    
    init(window: UIWindow?,
         container: Container,
         coordinatorFactory: CardFortressCoordinatorFactoryProtocol) {
        self.container = container
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        self.authenticationAPI = container.resolve(AuthenticationAPI.self)
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
        guard let coordinator = authenticationAPI?.coordinatorFactory.makeAuthCoordinator(window: window) else {
            return
            
        }
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


