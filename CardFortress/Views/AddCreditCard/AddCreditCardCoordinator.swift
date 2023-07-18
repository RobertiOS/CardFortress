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
    private let containter: Container
    private let factory: AddCreditCardFactoryProtocol & VisionKitFactoryProtocol
    private let addCreditCardViewController: AddCreditCardViewControllerProtocol
    
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController,
         containter: Container,
         factory: AddCreditCardFactoryProtocol & VisionKitFactoryProtocol) {
        self.navigationController = navigationController
        self.containter = containter
        self.factory = factory
        
        addCreditCardViewController = factory.makeAddCardViewController()
        super.init()
        addCreditCardViewController.delegate = self
    }
    
    override func start() {
        navigateTo(addCreditCardViewController, presentationStyle: .push)
    }

    //MARK: - Vision Coordinator
    
    private func startVisionKit() {
        let coordinator = VisionKitCoordinator(factory: factory, navigationController: navigationController)
    
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
    }
}

