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
    
    func makeMainListCoordinator() -> CardListCoordinating {
        listTabBarCoordinator
    }
    
    func makeAddCreditCardCoordinator() -> CardFortress.TabBarCoordinatorProtocol {
        addCreditCardCoordiantor
    }
    
}
