//
//  CardListCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject
import Domain

protocol CardListCoordinatorDelegate: AnyObject {
    func signOut()
}

protocol CardListCoordinating: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    var delegate: CardListCoordinatorDelegate? { get set }
}

final class CardListCoordinator: Coordinator<Void>, CardListCoordinating {
    //MARK: properties
    var navigationController: UINavigationController
    private let viewControllerFactory: CardListViewControllerFactoryProtocol
    weak var delegate: CardListCoordinatorDelegate?
    private let container: Container
    
    //MARK: initialization
    init(viewControllerFactory: CardListViewControllerFactoryProtocol,
         navigationController: UINavigationController,
         container: Container) {
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.container = container
    }

    override func start() {
        let viewController = viewControllerFactory.makeMainListViewController(delegate: self)
        navigateTo(viewController, presentationStyle: .push)
    }
    
    private func starEditCreditCardCoordinator(creditCard: DomainCreditCard) {
        let addCreditCardAPI = container.resolve(AddCreditCardAPI.self)
        guard let editCreditCardCoordinator = addCreditCardAPI?.coordinatorFactory.makeEditCreditCardCoordinator(
            creditCard: creditCard,
            navigationController: navigationController
        ) else { return }
        
        addChild(coordinator: editCreditCardCoordinator)
        
        editCreditCardCoordinator.start()
    }
}

extension CardListCoordinator: CardListViewControllerDelegate {
    
    func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult {
        //no op
        return .success
    }
    
    func editCreditCard(creditCard: DomainCreditCard) {
        starEditCreditCardCoordinator(creditCard: creditCard)
    }
    
    func signOut() {
        delegate?.signOut()
    }
}

#if DEBUG
extension CardListCoordinator {
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    
    struct TestHooks {
        let target: CardListCoordinator
        
        init(target: CardListCoordinator) {
            self.target = target
        }
    }
}
#endif
