//
//  SceneDelegate+Setup.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import Foundation

extension SceneDelegate {
    func setUpDependencies() {
        //MARK: view models
      
        container.register(ListViewModelProtocol.self) { r in
            ListViewModel()
        }
        //MARK: view controllers
        
        container.register(ListViewController.self) { r in
            ListViewController(viewModel: r.resolve(ListViewModelProtocol.self)!)
        }
    }
}
