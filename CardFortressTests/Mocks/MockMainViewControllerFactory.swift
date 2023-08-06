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
    let mockLoginViewController = UIViewController()
    
    //MARK: - AddCreditCardFactoryProtocol
    override func makeAddCardViewController() -> AddCreditCardViewControllerProtocol {
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
    
    override func makeLoginViewController(delegate: LoginViewDelegate? = nil) -> UIViewController {
        mockLoginViewController
    }
}


final class CardListViewControllerMock: UIViewController, CardListViewControllerProtocol {

}

final class AddCreditCardViewControllerMock: UIViewController ,AddCreditCardViewControllerProtocol {
    var viewModel: AddCreditCardViewController.ViewModel = .init(service: MockListService())
    var delegate: AddCreditCardCoordinatorDelegate?
}

final class MockVisionVC: UIViewController, VisionKitViewControllerProtocol {
    var delegate: VNDocumentCameraViewControllerDelegate?
}
