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

final class MainCoordinator: Coordinator {
    //MARK: properties
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let container: Container
    
    //MARK: initialization
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        guard let viewController = container.resolve(ListViewController.self) else { return }
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailView() {
        let secondVC = UIViewController(nibName: nil, bundle: nil)
        secondVC.navigationItem.title = "hola"
        secondVC.view.backgroundColor = .red
        navigationController.present(secondVC, animated: true)
    }

}

extension MainCoordinator: MainCoordinatorDelegate {
    func presentAnotherVC() {
        showDetailView()
    }
}
