//
//  MockMainViewControllerFactory.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 6/27/23.
//

import Foundation
import VisionKit
import Swinject
@testable import CardFortress

final class MockMainViewControllerFactory: MainViewControllerFactory {
    
    convenience init() {
        self.init(container: Container())
    }
    
    //MARK: - Properties
    
    let navigationController = UINavigationController()
    let cardListViewControllerMock = CardListViewControllerMock()
    let addCreditCardViewControllerMock =  AddCreditCardViewControllerMock()
    let mockVisionVC = MockVisionVC()
    let mockCreateUserView = CreateUserView(viewModel: .init())
    
    //MARK: - AddCreditCardFactoryProtocol
    override func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewControllerProtocol {
        addCreditCardViewControllerMock
    }
    
    //MARK: - CreditCardListFactoryProtocol
    
    override func makeNavigationController(tabBarItem: UITabBarItem?) -> UINavigationController {
        UINavigationController()
    }
    
    override func makeMainListViewController() -> CardListViewControllerProtocol {
        cardListViewControllerMock
    }

    //MARK: - VisionKitFactoryProtocol
    
    override func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        mockVisionVC
    }
    
    //MARK: - LoginFactoryProtocol
    @MainActor
    override func makeLoginView(delegate: LoginViewDelegate?) -> LoginView {
        LoginView(viewModel: .init())
    }
    
    override func makeCreateUserView(delegate: CreateUserViewDelegate?) -> CreateUserView {
        mockCreateUserView
    }
}


final class CardListViewControllerMock: UIViewController, CardListViewControllerProtocol {
    var viewModel: CardFortress.ListViewModelProtocol = MockListViewModel(cardListService: MockListService())
    var delegate: CardFortress.CardListViewControllerDelegate?
}

final class AddCreditCardViewControllerMock: UIViewController ,AddCreditCardViewControllerProtocol {
    var viewModel: AddCreditCardViewController.ViewModel = .init(service: MockListService(), action: .addCreditCard)
    var delegate: AddCreditCardCoordinatorDelegate?
}

final class MockVisionVC: UIViewController, VisionKitViewControllerProtocol {
    var delegate: VNDocumentCameraViewControllerDelegate?
}
