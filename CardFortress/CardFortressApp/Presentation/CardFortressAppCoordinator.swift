//
//  CardFortressTabBarCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Combine
import Swinject

final class CardFortressAppCoordinator: Coordinator<Void> {

    // MARK: properties
    private let window: UIWindow?
    private let container: Container
    private let coordinatorFactory: CardFortressCoordinatorFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?
    private var subscriptions = Set<AnyCancellable>()
    private var loginCoordinator: AuthCoordinating!
    private var tabBarCoordinator: TabBarContainerCoordinating!
    
    // MARK: initialization
    
    init(
        window: UIWindow?,
        container: Container,
        coordinatorFactory: CardFortressCoordinatorFactoryProtocol
    ) {
        self.container = container
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        self.authenticationAPI = container.resolve(AuthenticationAPI.self)
        super.init()
        setUpSubscriptions()
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
        tabBarCoordinator = coordinatorFactory.makeTabBarCoordinator(window: window)
        tabBarCoordinator.onFinish = { [weak self] result in
            switch result {
            case .signOut:
                _ = self?.authenticationAPI?.signOut()
                break
            }
        }
        tabBarCoordinator.start()
    }

    func startLoginCoordinator() {
        loginCoordinator = authenticationAPI?.coordinatorFactory.makeAuthCoordinator(window: window)
        loginCoordinator.start()
    }
    
    func setUpSubscriptions() {
        authenticationAPI?.isUserLoggedInPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isUserLoggedIn in
                if isUserLoggedIn {
                    self?.loginCoordinator = nil
                    self?.startTabBarCoordinator()
                } else {
                    self?.tabBarCoordinator = nil
                    self?.startLoginCoordinator()
                }
            }
            .store(in: &subscriptions)
    }
}


