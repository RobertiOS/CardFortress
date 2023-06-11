//
//  CardFortressRootCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Swinject

enum CardFortressResultCoordinator {
    case success
}

final class CardFortressRootCoordinator: Coordinator<CardFortressResultCoordinator> {

    // MARK: properties
    private let window: UIWindow?
    private let container: Container
    private let navigationController: UINavigationController
    private let viewControllerFactory: RootVCFactoryProtocol
    private let coordinatorFactory: CoordinatorFactory
    private let containerTabBarController = UITabBarController.init()

    // MARK: initialization
    
    convenience init(window: UIWindow?,
                     container: Container) {
        self.init(
            window: window,
            container: container,
            coordinatorFactory: CoordinatorFactory(
                container: container,
                viewControllerFactory: MainViewControllerFactory(container: container)
            ),
            viewControllerFactory: RootVCFactory(),
            tabs: [.main, .add]
        )
    }
    
    init(window: UIWindow?,
         container: Container,
         coordinatorFactory: CoordinatorFactory,
         viewControllerFactory: RootVCFactoryProtocol,
         tabs: [TabBarCoordinatorIndex]) {
        self.container = container
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = viewControllerFactory.makeNavigationController()
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        super.init()
        self.setTabs(tabsIndexes: tabs)
        window?.rootViewController = containerTabBarController
    }
    
    // MARK: actions
    
    override func start() {
        
        /// map view controllers
        let viewControllers = tabs.map { $0.coordinator.navigationController }
        
        /// start coordinators
        tabs.forEach { $0.coordinator.start() }
        
        /// set view controllers
        containerTabBarController.setViewControllers(viewControllers, animated: false)
        
    }
    
    // MARK: - TabBar

    struct Tab {
        let coordinator: TabBarCoordinatorProtocol
        let index: TabBarCoordinatorIndex
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
