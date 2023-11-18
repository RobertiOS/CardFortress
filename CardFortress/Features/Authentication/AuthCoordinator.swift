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

protocol AuthCoordinating: Coordinator<LoginCoordinatorResult>, NavigationCoordinator {
}

class AuthCoordinator: Coordinator<LoginCoordinatorResult>, AuthCoordinating, ObservableObject {

    var navigationController: UINavigationController
    private let factory: AuthenticationFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?
    private let secureUserDataAPI: SecureUserDataAPI?

    init(factory: AuthenticationFactoryProtocol,
         navigationController: UINavigationController,
         authenticationAPI: AuthenticationAPI?,
         secureUserDataAPI: SecureUserDataAPI?) {
        self.factory = factory
        self.navigationController = navigationController
        self.authenticationAPI = authenticationAPI
        self.secureUserDataAPI = secureUserDataAPI
        super.init()
    }

    override func start() {
        super.start()
        let loginView = factory.makeLoginView(delegate: self)
        let hostingController = UIHostingController(rootView: loginView)
        navigateTo(hostingController, presentationStyle: .push)
    }
}

//MARK: - LoginViewDelegate

extension AuthCoordinator: LoginViewDelegate {
    func getUserCredentials() async -> (email: String, password: String)? {
        let userData = await secureUserDataAPI?.getUserCredentials()
        if case .success(let loginInfo) = userData {
            return (email: loginInfo.userName, password: loginInfo.password)
        } else {
            return nil
        }
    }
    
    func loginWithBiometrics() async -> AuthenticationResult? {
        let result = await authenticationAPI?.signInWithBiometrics()
        await handleAuthResult(result)
        return result
    }

    func login(email: String, password: String) async -> AuthenticationResult? {
        let result = await authenticationAPI?.signIn(withEmail: email, password: password)
        await handleAuthResult(result)
        return result
    }
    
    func startCreateUser() {
        let createUserView = factory.makeCreateUserView(delegate: self)
        let hostingController = UIHostingController(rootView: createUserView)
        navigateTo(hostingController, presentationStyle: .present())
    }
}

//MARK: - CreateUserDelegate

extension AuthCoordinator: CreateUserViewDelegate {
    func createUser(
        name: String,
        lastName: String,
        email: String,
        password: String
    ) async -> AuthenticationResult {
        guard let authenticationAPI else { return .unkown }
        let result = await authenticationAPI.signUp(
            withEmail: email,
            password: password,
            name: name,
            lastName: lastName,
            image: nil
        )
        
        await handleAuthResult(result)
        
        return result
    }
    
    @MainActor
    func handleAuthResult(_ result: AuthenticationResult?) {
        switch result {
        case .success:
            navigationController.dismiss(animated: true)
            finish(.success)
        default:
            if let result {
                let presenter = navigationController.presentedViewController ?? navigationController
                presenter.presentAlert(with: result.errorMessage)
            }
        }
    }
}
