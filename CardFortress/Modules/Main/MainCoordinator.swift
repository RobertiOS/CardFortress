//
//  MainCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func presentAnotherVC()
}

final class MainCoordinator: Coordinator {
    //MARK: properties
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    //MARK: initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MainViewModel()
        viewModel.delegate = self
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension MainCoordinator: MainCoordinatorDelegate {
    func presentAnotherVC() {
        let secondVC = UIViewController(nibName: nil, bundle: nil)
        navigationController.pushViewController(secondVC, animated: true)
    }
}
