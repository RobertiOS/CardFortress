//
//  CardListAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import UIKit
import Swinject

protocol CardListAPI {
    func makeMainListCoordinator(tabBarItem: UITabBarItem) -> CardListCoordinating
}

final class CardListAPIImpl: CardListAPI {
    
    var coordinatorFactory: CardListCoordinatorFactoryProtocol
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
        
        self.coordinatorFactory = CardListCoordinatorFactory(container: container)
    }
    
    public func makeMainListCoordinator(tabBarItem: UITabBarItem) -> CardListCoordinating {
        coordinatorFactory.makeMainListCoordinator(tabBarItem: tabBarItem)
    }
    
}
