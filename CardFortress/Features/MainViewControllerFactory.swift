//
//  MainViewControllerFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/14/23.
//

import UIKit
import Swinject
import VisionKit
import SwiftUI

protocol CreditCardListFactoryProtocol: AnyObject {
    func makeMainListViewController() -> CardListViewControllerProtocol
    func makeNavigationController(
        tabBarItem: UITabBarItem?,
        rootViewController: UIViewController?
    ) -> UINavigationController
}

protocol AddCreditCardFactoryProtocol: AnyObject {
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewControllerProtocol
}

protocol VisionKitFactoryProtocol: AnyObject {
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
}

protocol AuthenticationFactoryProtocol: AnyObject {
    func makeLoginViewController(delegate: LoginViewDelegate?) -> UIViewController
    func makeCreateUserViewController(delegate: CreateUserViewDelegate?) -> UIViewController
}


class MainViewControllerFactory: CreditCardListFactoryProtocol,
                                       AddCreditCardFactoryProtocol,
                                       VisionKitFactoryProtocol,
                                 AuthenticationFactoryProtocol {
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    //MARK: - CreditCardListFactoryProtocol
    
    func makeMainListViewController() -> CardListViewControllerProtocol {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let listViewModel = ListViewModel(cardListService: service)
        let viewcontroller = CardListViewController(viewModel: listViewModel)
        return viewcontroller
        
    }
    
    func makeNavigationController(
        tabBarItem: UITabBarItem? = nil,
        rootViewController: UIViewController? = nil
    ) -> UINavigationController {
        var navigationController = UINavigationController()
        if let rootViewController {
            navigationController = UINavigationController(rootViewController: rootViewController)
        }
        if let tabBarItem {
            navigationController.tabBarItem = tabBarItem
        }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = UIColor.orange
        navigationController.navigationBar.backgroundColor = .systemBackground
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        return navigationController
    }
    
    //MARK: - AddCreditCardFactoryProtocol
    
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewControllerProtocol {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let viewModel = AddCreditCardViewController.ViewModel(service: service, action: action)
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
    //MARK: - VisionKitFactoryProtocol
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewController()
    }
    
    //MARK: - LoginFactoryProtocol

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
