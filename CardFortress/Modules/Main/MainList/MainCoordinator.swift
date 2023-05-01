//
//  MainCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

protocol MainCoordinatorDelegate: AnyObject {
    func presentAnotherVC()
}

enum MainCoordinatorResult {
    case success
}

final class MainCoordinator: Coordinator<MainCoordinatorResult>, NavigationCoordinator {
    //MARK: properties
    var navigationController: UINavigationController
    let container: Container
    
    //MARK: initialization
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }

    override func start() {
        guard let viewController = container.resolve(CardListViewController.self) else { return }
        viewController.delegate = self
        navigateTo(viewController, presentationStyle: .push)
    }
    /// start Another coordiantor
    func showAddCardCoordinator() {
        // No op
    }

}

extension MainCoordinator: MainCoordinatorDelegate {
    func presentAnotherVC() {
        showAddCardCoordinator()
    }
}
