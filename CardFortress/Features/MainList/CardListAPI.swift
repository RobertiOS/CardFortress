//
//  CardListAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Swinject

protocol CardListAPI {
    var coordinatorFactory: CardListCoordinatorFactoryProtocol { get }
}

final class CardListAPIImpl: CardListAPI {
    
    var coordinatorFactory: CardListCoordinatorFactoryProtocol
    private let container: Container
    
    internal init(container: Container) {
        self.container = container
        
        self.coordinatorFactory = CardListCoordinatorFactory(container: container)
    }
    
}
