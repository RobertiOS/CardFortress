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
}

final class AddCreditCardCoordinator: Coordinator<Void>, NavigationCoordinator, TabBarCoordinatorProtocol {
    
    //MARK: - Properties

    var navigationController: UINavigationController
    private let addCreditCardViewController: AddCreditCardViewControllerProtocol
    private let coordinatorFactory: VisionKitCoordinatorFactory
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController,
         factory: AddCreditCardFactoryProtocol,
         coordinatorFactory: VisionKitCoordinatorFactory) {
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
        addCreditCardViewController = factory.makeAddCardViewController()
        
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
                    self?.addCreditCardViewController.viewModel.creditCardNumber = String(creditCard.number)
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

