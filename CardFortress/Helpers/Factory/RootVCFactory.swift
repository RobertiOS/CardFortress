//
//  RootVCFactory.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/17/23.
//

import UIKit
import Swinject

protocol RootVCFactoryProtocol {
    func makeNavigationController() -> UINavigationController
}

final class RootVCFactory: RootVCFactoryProtocol {

    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .systemBackground
        navigationController.navigationBar.barTintColor = .red
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        return navigationController
    }
}
