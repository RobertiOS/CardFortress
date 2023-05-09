//
//  NavigationCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 24/04/23.
//

import Foundation
import UIKit

protocol NavigationCoordinator {
    var navigationController: UINavigationController { get set }
    func navigateTo(_ viewController: UIViewController,
                    presentationStyle: PresentationStyle,
                    animated: Bool)
}

extension NavigationCoordinator {
    func navigateTo(_ viewController: UIViewController,
                    presentationStyle: PresentationStyle,
                    animated: Bool = true) {
        switch presentationStyle {
        case .present(let completion):
            navigationController.present(viewController, animated: animated, completion: completion)
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
}

enum PresentationStyle {
    case present(completion: (() -> Void)? = nil)
    case push
}
