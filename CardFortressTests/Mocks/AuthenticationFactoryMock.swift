//
//  AuthenticationFactoryMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit
@testable import CardFortress

final class AuthenticationFactoryMock: AuthenticationFactoryProtocol {
    @MainActor
    func makeLoginView(delegate: CardFortress.LoginViewDelegate?) -> CardFortress.LoginView {
        LoginView(viewModel: .init())
    }
    
    func makeCreateUserView(delegate: CardFortress.CreateUserViewDelegate?) -> CardFortress.CreateUserView {
        CreateUserView(viewModel: .init())
    }
    
    
    let loginViewController = UIViewController()
    
    func makeLoginViewController(delegate: CardFortress.LoginViewDelegate?) -> UIViewController {
        loginViewController
    }
    
}
