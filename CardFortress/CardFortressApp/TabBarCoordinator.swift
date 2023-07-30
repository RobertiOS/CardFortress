//
//  TabBarCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import UIKit

final class TabBarCoordinator: Coordinator<Void> {
    private let coordinatorFactory: CoordinatorFactory
    private let containerTabBarController = UITabBarController.init()
    private let navigationController: UINavigationController
    
    init(coordinatorFactory: CoordinatorFactory,
         navigationController: UINavigationController) {
        self.coordinatorFactory = coordinatorFactory
        self.navigationController = navigationController
    }
    
    
    
    private var tabs: [Tab]  = []
    
    func setTabs(tabsIndexes: [TabBarCoordinatorIndex]) {
        tabs =  tabsIndexes.map {
            switch $0 {
            case .main:
                let mainCoordinator = coordinatorFactory.makeMainListCoordinator()
                return Tab(coordinator: mainCoordinator, index: $0)
            case .add:
                let addCoordinator = coordinatorFactory.makeAddCreditCardCoordinator()
                return Tab(coordinator: addCoordinator, index: $0)
            }
        }
    }
    
    override func start() {
        super.start()
        self.setTabs(tabsIndexes: [.main, .add])
        
        /// map view controllers
        let viewControllers = tabs.map { $0.coordinator.navigationController }
        
        /// start coordinators
        tabs.forEach { $0.coordinator.start() }
        
        /// set view controllers
        containerTabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.pushViewController(containerTabBarController, animated: true)
    }
}

extension TabBarCoordinator {
    struct Tab {
        let coordinator: TabBarCoordinatorProtocol
        let index: TabBarCoordinatorIndex
    }
}

enum TabBarCoordinatorIndex: CaseIterable {
    case main
    case add
    
    var image: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "list.bullet.rectangle")
        case .add:
            return UIImage(systemName: "rectangle.stack.badge.plus")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "list.bullet.rectangle.fill")
        case .add:
            return UIImage(systemName: "rectangle.stack.fill.badge.plus")
        }
    }
    
    var title: String? {
        switch self {
        case .main:
            return "Cards"
        case .add:
            return "Add New"
        }
    }
}


extension TabBarCoordinator {
    
    var testHooks: TestHooks {
        .init(target: self)
    }
    
    struct TestHooks {
        let target: TabBarCoordinator
        
        init(target: TabBarCoordinator) {
            self.target = target
        }
        
        var tabs: [Tab] {
            target.tabs
        }
        
        var tabBarController: UITabBarController {
            target.containerTabBarController
        }
    }
}
