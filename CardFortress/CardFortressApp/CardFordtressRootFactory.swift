//
//  CardFordtressRootFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/17/23.
//

import UIKit
import Swinject

protocol CardFordtressRootFactoryProtocol {
    func makeNavigationController() -> UINavigationController
    func makeMainListFactory() -> MainListFactoryProtocol
}

final class CardFordtressRootFactory: CardFordtressRootFactoryProtocol {
    
    //MARK: properties
    private let container: Container
    
    //MARK: initialization
    init(container: Container) {
        self.container = container
    }

    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .systemBackground
        navigationController.navigationBar.barTintColor = .red
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        return navigationController
    }
    
    func makeMainListFactory() -> MainListFactoryProtocol {
        MainListFactory(container: container)
    }
}
