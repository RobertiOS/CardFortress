//
//  AddCreditCardAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import Foundation
import Swinject

protocol AddCreditCardAPI {
    var coordinatorFactory: AddCreditCardCoordinatorFactoryProtocol { get }
}

final class AddCreditCardAPIImpl: AddCreditCardAPI {
    private let container: Container
    var coordinatorFactory: AddCreditCardCoordinatorFactoryProtocol
    
    init(container: Container) {
        self.container = container
        let service = container.resolve(CardListServiceProtocol.self)!
        let viewControllerFactory = AddCreditCardViewControllerFactory(service: service)
        self.coordinatorFactory = AddCreditCardCoordinatorFactory(viewControllerFactory: viewControllerFactory)
    }
    
}
