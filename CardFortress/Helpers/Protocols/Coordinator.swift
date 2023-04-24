//
//  Coordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit

class Coordinator<CoordinatorResult> {

    private var childCoordinators: [UUID: Any]  = [:]
    private let identifier = UUID()

    open func start() { }
    /// The block performed when the coordinator has finished its flow
    var onFinish: ((CoordinatorResult) -> Void)?

    private var cleanupFromParentBlock: (() -> Void)?

    public func addChild<T>(coordinator: Coordinator<T>) {
        coordinator.cleanupFromParentBlock = { [weak self, weak coordinator] in
            self?.removeChild(coordinator: coordinator)
        }
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func removeChild<T>(coordinator: Coordinator<T>?) {
        guard let coordinator else { return }
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }

    open func finish(_ result: CoordinatorResult) {
        onFinish?(result)
        cleanupFromParentBlock?()
    }
}

protocol NavigationCoordinator {
    var navigationController: UINavigationController { get set }
}

extension NavigationCoordinator {
    func navigateTo(_ viewController: UIViewController,
                    presentationStyle: PresentationStyle,
                    animated: Bool = true) {
        switch presentationStyle {
        case .present:
            navigationController.present(viewController, animated: animated)
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
}

enum PresentationStyle {
    case present
    case push
}
