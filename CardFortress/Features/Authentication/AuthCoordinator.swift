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

protocol AuthCoordinating: Coordinator<LoginCoordinatorResult>, NavigationCoordinator {}

class AuthCoordinator: Coordinator<LoginCoordinatorResult>, AuthCoordinating, ObservableObject {

    internal var navigationController: UINavigationController
    private let factory: AuthenticationFactoryProtocol
    private let authenticationAPI: AuthenticationAPI?
    private let secureUserDataAPI: SecureUserDataAPI?
    private let window: UIWindow?
    private lazy var loginViewController: UIViewController = {
        factory.makeLoginViewController(delegate: self)
    }()

    init(factory: AuthenticationFactoryProtocol,
         authenticationAPI: AuthenticationAPI?,
         secureUserDataAPI: SecureUserDataAPI?,
         window: UIWindow?,
         navigationController: UINavigationController = UINavigationController()) {
        self.factory = factory
        self.authenticationAPI = authenticationAPI
        self.secureUserDataAPI = secureUserDataAPI
        self.window = window
        self.navigationController = navigationController
        super.init()
    }

    override func start() {
        super.start()
        navigateTo(
            loginViewController,
            presentationStyle: .push
        )
        UIView.transition(with: window!, duration: 0.5, options: .transitionCurlUp, animations: {
            self.window?.rootViewController = self.navigationController
        }, completion: nil)
    }
    
    func startCreateUser() {
        let createUserViewController = factory.makeCreateUserViewController(delegate: self)
        navigateTo(
            createUserViewController,
            presentationStyle: .present()
        )
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
            finish(.success)
        default:
            if let result {
                let presenter = navigationController.presentedViewController ?? navigationController
                presenter.presentAlert(with: result.errorMessage)
            }
        }
    }
}
