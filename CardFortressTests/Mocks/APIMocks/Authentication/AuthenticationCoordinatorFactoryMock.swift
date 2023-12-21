//
//  AuthenticationCoordinatorFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit

final class AuthenticationCoordinatorFactoryMock: AuthenticationCoordinatorFactoryProtocol {
    func makeAuthCoordinator(window: UIWindow?) -> AuthCoordinating {
        MockLoginCoordinator()
    }
}

final class MockLoginCoordinator: AuthCoordinator {
    var startCalledCount = 0
    
    override func start() {
        startCalledCount += 1
    }
    
    convenience init() {
        self.init(factory: AuthViewControllerFactoryMock(),
                  authenticationAPI: AuthenticationAPIMock(),
                  secureUserDataAPI: SecureUserDataAPIMock(),
                  window: UIWindow()
        )
    }
}
