//
//  AuthViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/15/23.
//

import UIKit

protocol AuthViewControllerFactoryProtocol: AnyObject {
    func makeLoginViewController(delegate: LoginViewDelegate?) -> UIViewController
    func makeCreateUserViewController(delegate: CreateUserViewDelegate?) -> UIViewController
}

final class AuthViewControllerFactory: AuthViewControllerFactoryProtocol {

    @MainActor
    func makeLoginViewController(delegate: LoginViewDelegate?) -> UIViewController {
        let viewModel = LoginView.ViewModel()
        viewModel.delegate = delegate
        let view = LoginView(viewModel: viewModel)
        return UIHostingControllerWrapper(rootView: view)
    }

    func makeCreateUserViewController(delegate: CreateUserViewDelegate?) -> UIViewController {
        let viewModel = CreateUserViewModel()
        viewModel.delegate = delegate
        let view = CreateUserView(viewModel: viewModel)
        return UIHostingControllerWrapper(rootView: view)
    }
}
