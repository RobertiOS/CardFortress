//
//  AuthCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import UIKit
import Swinject
import SwiftUI

enum LoginCoordinatorResult {
    case success
    case failure(error: Error)
}

enum AuthRoutes {
    case signIn
    case signUp
}

class AuthCoordinator: Coordinator<LoginCoordinatorResult>, NavigationCoordinator, ObservableObject {

    var navigationController: UINavigationController
    private let factory: AuthenticationFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?

    init(factory: AuthenticationFactoryProtocol,
         navigationController: UINavigationController,
         authenticationAPI: AuthenticationAPI?) {
        self.factory = factory
        self.navigationController = navigationController
        self.authenticationAPI = authenticationAPI
        super.init()
    }

    override func start() {
        super.start()
        let loginView = factory.makeLoginView(delegate: self)
            .environmentObject(self)
        let hostingController = UIHostingController(rootView: loginView)
        navigateTo(hostingController, presentationStyle: .push)
    }
}

extension AuthCoordinator: LoginViewDelegate {
    func login(email: String, password: String) async -> AuthenticationResult? {
        let result = await authenticationAPI?.signIn(withEmail: email, password: password)
        await handleLoginCoordinatorResult(result)
        return result
    }
    
    @MainActor
    func handleLoginCoordinatorResult(_ result: AuthenticationResult?) {
        switch result {
        case .success:
            navigationController.dismiss(animated: true)
            finish(.success)
        default:
            break
        }
    }
}
