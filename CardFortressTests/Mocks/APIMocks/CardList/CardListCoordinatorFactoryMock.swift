//
//  CardListCoordinatorFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit

final class CardListCoordinatorFactoryMock: CardListCoordinatorFactoryProtocol {
    func makeMainListCoordinator(tabBarItem: UITabBarItem) -> CardListCoordinating {
        CardListCoordinatorMock()
    }
}

final class CardListCoordinatorMock:Coordinator<Void>, CardListCoordinating {
    var delegate: CardListCoordinatorDelegate?
    var navigationController: UINavigationController = .init()
}
