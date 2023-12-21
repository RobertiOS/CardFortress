//
//  AuthViewControllerFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/16/23.
//

import UIKit

final class AuthViewControllerFactoryMock: AuthViewControllerFactoryProtocol {

    @MainActor
    func makeLoginViewController(delegate: LoginViewDelegate?) -> UIViewController {
        UIViewController()
    }

    func makeCreateUserViewController(delegate: CreateUserViewDelegate?) -> UIViewController {
        UIViewController()
    }
}
