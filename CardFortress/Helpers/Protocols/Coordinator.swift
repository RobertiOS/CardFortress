//
//  Coordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set}
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
