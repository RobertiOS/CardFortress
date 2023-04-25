//
//  SceneDelegate+Setup.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import Foundation
import UIKit

extension SceneDelegate {
    func setUpDependencies() {
        //MARK: view models
      
        container.register(ListViewModelProtocol.self) { r in
            ListViewModel()
        }
        //MARK: view controllers
        
        container.register(CardListViewController.self) { r in
            CardListViewController(viewModel: r.resolve(ListViewModelProtocol.self)!)
        }
        
        container.register(UINavigationController.self) { r in
            let navigationController: UINavigationController = .init()
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.isTranslucent = false
            return navigationController
        }
    }
}
