//
//  AuthenticationCoordinatorFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/15/23.
//

import UIKit
import Swinject

protocol AuthenticationCoordinatorFactoryProtocol {
    func makeAuthCoordinator(window: UIWindow?) -> AuthCoordinating
}

final class AuthenticationCoordinatorFactory: AuthenticationCoordinatorFactoryProtocol {
    
    private let container: Container
    private let factory: AuthViewControllerFactoryProtocol
    
    internal init(container: Container, factory: AuthViewControllerFactoryProtocol) {
        self.container = container
        self.factory = factory
    }

    func makeAuthCoordinator(window: UIWindow?) -> AuthCoordinating {
        let authenticationAPI = container.resolve(AuthenticationAPI.self)
        let secureUserDataAPI = container.resolve(SecureUserDataAPI.self)
        return AuthCoordinator(
            factory: factory,
            authenticationAPI: authenticationAPI,
            secureUserDataAPI: secureUserDataAPI,
            window: window
        )
    }
}
