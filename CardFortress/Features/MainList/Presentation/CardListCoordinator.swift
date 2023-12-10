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
    weak var delegate: CardListCoordinatorDelegate?
    private var editCreditCardCoordinator: AddCreditCardCoordinator?
    private let coordinatorFactory: EditCreditCardCoodinatorFactory
    
    //MARK: initialization
    init(viewControllerFactory: CreditCardListFactoryProtocol,
         navigationController: UINavigationController,
         coordinatorFactory: EditCreditCardCoodinatorFactory) {
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        let viewController = viewControllerFactory.makeMainListViewController()
        viewController.delegate = self
        navigateTo(viewController, presentationStyle: .push)
    }
    
    private func starEditCreditCardCoordinator(creditCard: CreditCard) {
        editCreditCardCoordinator = coordinatorFactory.makeEditCreditCardCoordinator(
            creditCard: creditCard,
            navigationController: navigationController
        )
        
        guard let editCreditCardCoordinator else { return }
        addChild(coordinator: editCreditCardCoordinator)
        editCreditCardCoordinator.onFinish = { [weak self] void in
            self?.editCreditCardCoordinator = nil
        }
        
        editCreditCardCoordinator.start()
    }
}

extension CardListCoordinator: CardListViewControllerDelegate {
    
    func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult {
        //no op
        return .success
    }
    
    func editCreditCard(creditCard: CreditCard) {
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
        
        var editCreditCardsCoordinator: AddCreditCardCoordinator? {
            target.editCreditCardCoordinator
        }
        
    }
}
#endif
