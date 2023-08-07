//
//  CardListCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

protocol CardListCoordinatorDelegate: AnyObject {
    func signOut()
}

protocol CardListCoordinating: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    var delegate: CardListCoordinatorDelegate? { get set }
}

final class CardListCoordinator: Coordinator<Void>, CardListCoordinating {
    //MARK: properties
    var navigationController: UINavigationController
    private let viewControllerFactory: CreditCardListFactoryProtocol
    private let container: Container
    weak var delegate: CardListCoordinatorDelegate?
    
    //MARK: initialization
    init(container: Container,
         viewControllerFactory: CreditCardListFactoryProtocol,
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
}

extension CardListCoordinator: CardListViewControllerDelegate {
    func signOut() {
        delegate?.signOut()
    }
}
