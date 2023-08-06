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
    func makeNavigationController(tabBarItem: UITabBarItem?) -> UINavigationController
}

protocol AddCreditCardFactoryProtocol: AnyObject {
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol
}

protocol VisionKitFactoryProtocol: AnyObject {
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
}

protocol LoginFactoryProtocol: AnyObject {
    func makeLoginViewController(delegate: LoginViewDelegate?) -> UIViewController
}


class MainViewControllerFactory: CreditCardListFactoryProtocol,
                                       AddCreditCardFactoryProtocol,
                                       VisionKitFactoryProtocol,
                                       LoginFactoryProtocol {
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
    
    func makeNavigationController(tabBarItem: UITabBarItem? = nil) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = UIColor.orange
        navigationController.navigationBar.backgroundColor = .systemBackground
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        if let tabBarItem {
            navigationController.tabBarItem = tabBarItem
        }
        return navigationController
    }
    
    //MARK: - AddCreditCardFactoryProtocol
    
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol {
        guard let service = container.resolve(CardListServiceProtocol.self) else { fatalError("Service must be registered") }
        let viewModel = AddCreditCardViewController.ViewModel(service: service)
        let viewController = AddCreditCardViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .systemBackground
        return viewController
    }
    
    //MARK: - VisionKitFactoryProtocol
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewController()
    }
    
    //MARK: - LoginFactoryProtocol
    
    func makeLoginViewController(delegate: LoginViewDelegate? = nil) -> UIViewController {
        let viewModel = LoginView.ViewModel()
        viewModel.delegate = delegate
        return UIHostingController(rootView: LoginView(viewModel: viewModel))
    }
}
