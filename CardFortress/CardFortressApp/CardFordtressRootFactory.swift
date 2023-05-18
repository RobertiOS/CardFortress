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
        let navigationController: UINavigationController = .init()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    func makeMainListFactory() -> MainListFactoryProtocol {
        MainListFactory(container: container)
    }
}
