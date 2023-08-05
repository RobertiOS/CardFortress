//
//  MockTabBarCoordinatorFactory.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit
@testable import CardFortress

final class MockTabBarCoordinatorFactory: TabBarCoordinatorFactory {
    
    let listTabBarCoordinator = MockTabBarCoordinator()
    let addCreditCardCoordiantor = MockTabBarCoordinator()
    var viewControllers: [UIViewController] {
        [listTabBarCoordinator, addCreditCardCoordiantor].map { c in
            c.navigationController
        }
    }
    
    func makeMainListCoordinator() -> CardFortress.TabBarCoordinatorProtocol {
        listTabBarCoordinator
    }
    
    func makeAddCreditCardCoordinator() -> CardFortress.TabBarCoordinatorProtocol {
        addCreditCardCoordiantor
    }
    
}

extension MockTabBarCoordinatorFactory {
    final class MockTabBarCoordinator: Coordinator<Void>, TabBarCoordinatorProtocol {
        var navigationController: UINavigationController = UINavigationController(rootViewController: UIViewController())
    }
}
