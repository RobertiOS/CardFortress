//
//  AuthenticationAPIMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit
import Combine

final class AuthenticationAPIMock: AuthenticationAPI {
    
    private let isLoggedInSubject: PassthroughSubject<Bool, Never> = .init()

    var isUserLoggedIn: Bool = false {
        didSet {
            isLoggedInSubject.send(isUserLoggedIn)
        }
    }

    var coordinatorFactory: AuthenticationCoordinatorFactoryProtocol = AuthenticationCoordinatorFactoryMock()
    
    var currentUser: CurrentUser?
    
    func makeAuthCoordinator(window: UIWindow?, factory: AuthViewControllerFactoryProtocol) -> AuthCoordinating {
        MockLoginCoordinator()
    }

    func signInWithBiometrics() async -> AuthenticationResult {
        .success
    }
    
    func signUp(withEmail: String, password: String, name: String, lastName: String, image: UIImage?) async -> AuthenticationResult {
        isUserLoggedIn = true
        return .success
    }
    
    func signOut() -> AuthenticationResult {
        .success
    }
    
    func signIn(withEmail: String, password: String) async -> AuthenticationResult {
        return .success
    }
    
    var isUserLoggedInPublisher: AnyPublisher<Bool, Never> {
        isLoggedInSubject.eraseToAnyPublisher()
    }
    
}
