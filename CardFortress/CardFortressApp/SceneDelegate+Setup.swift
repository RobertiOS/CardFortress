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
        
        //MARK: service and secure store
        
        container.register(SecureStore.self) { r in
            SecureStore(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
        }
        
        container.register(CardListService.self) { r in
            CardListService(secureStore: r.resolve(SecureStore.self)!)
        }
        
        //MARK: view models
      
        container.register(ListViewModelProtocol.self) { r in
            ListViewModel(cardListService: r.resolve(CardListService.self)!)
        }
        //MARK: view controllers
        
        container.register(CardListViewController.self) { r in
            CardListViewController(viewModel: r.resolve(ListViewModelProtocol.self)!)
        }
        
        container.register(UINavigationController.self) { r in
            let navigationController: UINavigationController = .init()
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
}
