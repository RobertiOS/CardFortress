//
//  CardFortressCoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/15/23.
//

import UIKit
import Swinject

protocol CardFortressCoordinatorFactoryProtocol {
    func makeTabBarCoordinator(window: UIWindow?) -> TabBarContainerCoordinating
    func makeMainListCoordinator<T: CardListCoordinatorDelegate>(delegate: T) -> TabBarCoordinatorProtocol
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol
}

final class CardFortressCoordinatorFactory: CardFortressCoordinatorFactoryProtocol {
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
    }
    
    func makeTabBarCoordinator(window: UIWindow?) -> TabBarContainerCoordinating {
        TabBarContainerCoordinator(
            coordinatorFactory: self,
            window: window,
            container: container
        )
    }
    
    func makeMainListCoordinator<T: CardListCoordinatorDelegate>(delegate: T) -> TabBarCoordinatorProtocol {
        let cardListAPI = container.resolve(CardListAPI.self)!
        let coordinator = cardListAPI.coordinatorFactory.makeMainListCoordinator(tabBarItem: .init(tabBarIndex: .main)) as! CardListCoordinator
        coordinator.delegate = delegate
        return coordinator
    }
    
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol {
        let addCreditCardAPI = container.resolve(AddCreditCardAPI.self)!
        let coordinator = addCreditCardAPI.coordinatorFactory.makeAddCreditCardCoordinator(
            tabBarItem: .init(tabBarIndex: .add)
        )
        return coordinator
    }
}

extension AddCreditCardCoordinator: TabBarCoordinatorProtocol {}
extension CardListCoordinator: TabBarCoordinatorProtocol {}
