//
//  TabBarCoordinatorProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/10/23.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator<Void> {
    var navigationController: UINavigationController { get set }
}
