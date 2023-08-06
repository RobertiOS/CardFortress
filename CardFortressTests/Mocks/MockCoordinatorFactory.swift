//
//  MockCoordinatorFactory.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/6/23.
//

import UIKit
import Swinject
@testable import CardFortress

final class MockCoordinatorFactory: CoordinatorFactory {
    
    convenience init() {
        self.init(
            container: Container(),
            viewControllerFactory: MockMainViewControllerFactory()
        )
    }
    
    //MARK: - Properties
    
    let listTabBarCoordinator = MockTabBarCoordinator()
    let addCreditCardCoordiantor = MockTabBarCoordinator()
    
    lazy var tabBarCoordinator = TabBarCoordinator(
        coordinatorFactory: self,
        navigationController: UINavigationController()
    )
    
    lazy var loginCoordinator = LoginCoordinator(
        factory: LoginFactoryMock(),
        navigationController: UINavigationController(),
        authenticationAPI: AuthenticationAPIMock()
    )
    
    //MARK: - Methods
    
    //MARK: - TabBarCoordinatorFactory
    
    override func makeMainListCoordinator() -> TabBarCoordinatorProtocol {
        listTabBarCoordinator
    }
    
    override func makeAddCreditCardCoordinator() -> TabBarCoordinatorProtocol {
        addCreditCardCoordiantor
    }
    
    //MARK: - AppCoordinatorFactory
    
    override func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        tabBarCoordinator
    }
    
    //MARK: - LoginCoordinatorFactory
    
    override func makeLoginCoordinator(navigationController: UINavigationController) -> LoginCoordinator {
        loginCoordinator
    }
}

final class MockTabBarCoordinator: Coordinator<Void>, TabBarCoordinatorProtocol {
    var navigationController: UINavigationController = UINavigationController(rootViewController: UIViewController())
}
