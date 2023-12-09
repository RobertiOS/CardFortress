//
//  AddCreditCardCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/10/23.
//

import UIKit
import Swinject
import VisionKit
import Vision

protocol AddCreditCardCoordinatorDelegate: AnyObject {
    func startVisionKitCoordinator()
    func viewControllerWillDissapear()
}

extension AddCreditCardCoordinatorDelegate {
    func viewControllerWillDissapear() {}
}

final class AddCreditCardCoordinator: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    
    enum Action: Equatable {
        var id: Int {
            switch self {
            case .addCreditCard:
                return 0
            case .editCreditCard:
                return 1
            }
        }

        case addCreditCard
        case editCreditCard(CreditCard)
    }
    
    //MARK: - Properties
    var navigationController: UINavigationController
    private let addCreditCardViewController: AddCreditCardViewControllerProtocol
    private let coordinatorFactory: VisionKitCoordinatorFactory
    //MARK: - Initialization
    
    init(navigationController: UINavigationController,
         factory: AddCreditCardFactoryProtocol,
         coordinatorFactory: VisionKitCoordinatorFactory,
         action: Action = .addCreditCard) {
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
        addCreditCardViewController = factory.makeAddCardViewController(action: action)
        super.init()
        addCreditCardViewController.delegate = self
    }
    
    override func start() {
        navigateTo(addCreditCardViewController, presentationStyle: .push)
    }

    //MARK: - Vision Coordinator
    
    private func startVisionKit() {
        let coordinator = coordinatorFactory.makeVisionKitCoordinator(navigationController: navigationController)
    
        coordinator.onFinish = { [weak self] in
            switch $0 {
            case .successfulScan(let creditCard):
                if let creditCard {
                    self?.addCreditCardViewController.viewModel.creditCardDate = creditCard.date
                    self?.addCreditCardViewController.viewModel.creditCardNumber = creditCard.number
                    self?.addCreditCardViewController.viewModel.creditCardHolderName = creditCard.cardHolderName
                    self?.addCreditCardViewController.viewModel.creditCardName = creditCard.cardName
                }
            case .userCancelled:
                return
            case .withError(_):
                //TODO: - Error handling
                return
            }
        }
        
        addChild(coordinator: coordinator)
        coordinator.start()
    }
    
}

//MARK: - AddCreditCardCoordinatorDelegate

extension AddCreditCardCoordinator: AddCreditCardCoordinatorDelegate {
    func startVisionKitCoordinator() {
        startVisionKit()
    }
    
    func viewControllerWillDissapear() {
        if case .editCreditCard = addCreditCardViewController.viewModel.action {
            self.finish(())
        }
    }
}

//MARK: - Testhooks

extension AddCreditCardCoordinator {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    
    struct TestHooks {
        let target: AddCreditCardCoordinator
        init(target: AddCreditCardCoordinator) {
            self.target = target
        }
        
        func startVisionKitCoordinator() {
            target.startVisionKitCoordinator()
        }
        
        var addCreditCardVCViewModel: AddCreditCardViewController.ViewModel {
            target.addCreditCardViewController.viewModel
        }
    }
}

