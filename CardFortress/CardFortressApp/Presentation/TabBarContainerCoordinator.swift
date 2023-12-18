//
//  TabBarContainerCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import UIKit
import Swinject

enum TabBarCoordinatorResult {
    case signOut
}

protocol TabBarContainerCoordinating: Coordinator<TabBarCoordinatorResult> {
    
}

class TabBarContainerCoordinator: Coordinator<TabBarCoordinatorResult>, TabBarContainerCoordinating {
    private let coordinatorFactory: CardFortressCoordinatorFactoryProtocol
    private let containerTabBarController = UITabBarController()
    private let container: Container
    private let window: UIWindow?
    
    init(coordinatorFactory: CardFortressCoordinatorFactoryProtocol,
         window: UIWindow?,
         container: Container = Container()) {
        self.coordinatorFactory = coordinatorFactory
        self.window = window
        self.container = container
    }
    
    
    
    private var tabs: [Tab]  = []
    
    func setTabs(tabsIndexes: [TabBarCoordinatorIndex]) {
        tabs =  tabsIndexes.map {
            switch $0 {
            case .main:
                let mainCoordinator = coordinatorFactory.makeMainListCoordinator(delegate: self)
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
        
        animateWindowChanges()
    }
    
    func animateWindowChanges() {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCurlDown) {
            window.rootViewController = self.containerTabBarController
        }
    }
}

extension TabBarContainerCoordinator {
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


extension TabBarContainerCoordinator {
    
    var testHooks: TestHooks {
        .init(target: self)
    }
    
    struct TestHooks {
        let target: TabBarContainerCoordinator
        
        init(target: TabBarContainerCoordinator) {
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

extension TabBarContainerCoordinator: CardListCoordinatorDelegate {
    func signOut() {
        guard let authAPI = container.resolve(AuthenticationAPI.self) else { return }
        
        if case .other(_) = authAPI.signOut() {
            // TODO: - Handle error
        } else  {
            finish(.signOut)
        }
    }
}
