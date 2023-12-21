//
//  CardFortressCoordinatorFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit

final class CardFortressCoordinatorFactoryMock: CardFortressCoordinatorFactoryProtocol {
    
    func makeTabBarCoordinator(window: UIWindow?) -> TabBarContainerCoordinating {
        TabBarCoordinatorMock()
    }
    
    func makeMainListCoordinator<T>(delegate: T) -> TabBarCoordinatorProtocol where T : CardListCoordinatorDelegate {
        CardListCoordinatorMock()
    }
    
    func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol {
        AddCreditCardCoordinatorFactoryMock().makeAddCreditCardCoordinator(tabBarItem: .init(tabBarIndex: .add))
    }
}

extension CardListCoordinatorMock: TabBarCoordinatorProtocol {}

final class TabBarCoordinatorMock: Coordinator<TabBarCoordinatorResult>, TabBarContainerCoordinating {
    
}
