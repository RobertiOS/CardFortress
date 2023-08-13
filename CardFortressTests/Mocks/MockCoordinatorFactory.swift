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
    let visionKitCoordinator = MockVisionKitCoordinator()
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
    
    override func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating {
        loginCoordinator
    }
    
    //MARK: - Vision kit factory
    
    override func makeVisionKitCoordinator(navigationController: UINavigationController) -> VisionKitCoordinating {
        visionKitCoordinator
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

final class MockLoginCoordinator: AuthCoordinator {
    var startCalledCount = 0
    
    override func start() {
        startCalledCount += 1
    }
    
    convenience init() {
        self.init(factory: AuthenticationFactoryMock(),
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

final class MockVisionKitCoordinator: Coordinator<VisionKitResult>, VisionKitCoordinating {
    var navigationController: UINavigationController = .init()
    
    var startCalledCount = 0
    
    override func start() {
        super.start()
        startCalledCount += 1
    }
}
