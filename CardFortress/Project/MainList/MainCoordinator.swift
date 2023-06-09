//
//  MainCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

protocol MainCoordinatorDelegate: AnyObject {
}

enum MainCoordinatorResult {
    case success
}

final class MainCoordinator: Coordinator<MainCoordinatorResult>, NavigationCoordinator {
    //MARK: properties
    var navigationController: UINavigationController
    private let viewControllerFactory: MainListFactoryProtocol
    private let container: Container
    
    //MARK: initialization
    init(container: Container,
         viewControllerFactory: MainListFactoryProtocol,
         navigationController: UINavigationController) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = viewControllerFactory.makeMainListViewController()
        viewController.delegate = self
        navigateTo(viewController, presentationStyle: .push)
    }
    /// start Another coordiantor
    func showAddCardCoordinator() {
        // No op
    }

}

extension MainCoordinator: MainCoordinatorDelegate {
}
