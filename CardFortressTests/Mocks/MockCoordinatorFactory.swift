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
    
    lazy var tabBarCoordinator = MockTabBarCoordinatorContainer(
        coordinatorFactory: self
    )
    
    let loginCoordinator = MockLoginCoordinator()
    
    //MARK: - Methods
    
    //MARK: - TabBarCoordinatorFactory
    
    override func makeMainListCoordinator() -> CardListCoordinating {
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

final class MockTabBarCoordinator: Coordinator<Void>, CardListCoordinating {
    var delegate: CardListCoordinatorDelegate?
    
    var navigationController: UINavigationController = UINavigationController(rootViewController: UIViewController())
    var startCalledCount = 0
    
    override func start() {
        startCalledCount += 1
    }
}

final class MockLoginCoordinator: LoginCoordinator {
    var startCalledCount = 0
    
    override func start() {
        startCalledCount += 1
    }
    
    convenience init() {
        self.init(factory: LoginFactoryMock(),
                  navigationController: UINavigationController(),
                  authenticationAPI: AuthenticationAPIMock()
        )
    }
}

final class MockTabBarCoordinatorContainer: TabBarCoordinator {
    var startCalledCount = 0
    
    override func start() {
        startCalledCount += 1
    }
    
    convenience init(coordinatorFactory: TabBarCoordinatorFactory) {
        self.init(
            coordinatorFactory: coordinatorFactory,
            navigationController: UINavigationController(),
            container: Container())
    }
}
