//
//  LoginCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import UIKit
import Swinject

final class LoginCoordinator: Coordinator<LoginCoordinator.LoginCoordinatorResult>, NavigationCoordinator {
    
    var navigationController: UINavigationController
    private let factory: LoginFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?
    private var loginViewController: UIViewController = .init()

    init(factory: LoginFactoryProtocol,
         navigationController: UINavigationController,
         authenticationAPI: AuthenticationAPI?) {
        self.factory = factory
        self.navigationController = navigationController
        self.authenticationAPI = authenticationAPI
        super.init()
    }

    override func start() {
        super.start()
        self.loginViewController = factory.makeLoginViewController(delegate: self)
        navigateTo(loginViewController, presentationStyle: .push)
    }
}

extension LoginCoordinator: LoginViewDelegate {
    func login(email: String, password: String) async -> AuthenticationResult? {
        let result = await authenticationAPI?.signIn(withEmail: email, password: password)
        await handleLoginCoordinatorResult(result)
        return result
    }
    
    @MainActor
    func handleLoginCoordinatorResult(_ result: AuthenticationResult?) {
        switch result {
        case .success:
            Task(priority: .userInitiated) { [weak self] in
                self?.loginViewController.dismiss(animated: true)
                self?.finish(.success)
 
            }
        default:
            break
        }
    }
}

extension LoginCoordinator {
    enum LoginCoordinatorResult {
        case success
        case failure(error: Error)
    }
}

