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
        let hostingController = UIHostingController(rootView: loginView)
        navigateTo(hostingController, presentationStyle: .push)
    }
}

//MARK: - LoginViewDelegate

extension AuthCoordinator: LoginViewDelegate {
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
            break
        }
    }
}
