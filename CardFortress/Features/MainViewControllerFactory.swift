////
////  MainViewControllerFactory.swift
////  CardFortress
////
////  Created by Roberto Corrales on 5/14/23.
////
//
//import UIKit
//import Swinject
//import VisionKit
//import SwiftUI
//
//protocol CreditCardListFactoryProtocol: AnyObject {
//    func makeMainListViewController() -> CardListViewControllerProtocol
//    func makeNavigationController(
//        tabBarItem: UITabBarItem?,
//        rootViewController: UIViewController?
//    ) -> UINavigationController
//}
//
//protocol AddCreditCardFactoryProtocol: AnyObject {
//    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewControllerProtocol
//}
//
//protocol VisionKitFactoryProtocol: AnyObject {
//    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol
//}
//
//
//class MainViewControllerFactory: CreditCardListFactoryProtocol,
//                                       AddCreditCardFactoryProtocol,
//                                       VisionKitFactoryProtocol {
//    private let container: Container
//    
//    init(container: Container) {
//        self.container = container
//    }
//    
//    //MARK: - CreditCardListFactoryProtocol
//    
//    
//    
//    func makeNavigationController(
//        tabBarItem: UITabBarItem? = nil,
//        rootViewController: UIViewController? = nil
//    ) -> UINavigationController {
//        var navigationController = UINavigationController()
//        if let rootViewController {
//            navigationController = UINavigationController(rootViewController: rootViewController)
//        }
//        if let tabBarItem {
//            navigationController.tabBarItem = tabBarItem
//        }
//        navigationController.navigationBar.prefersLargeTitles = true
//        navigationController.navigationBar.backgroundColor = UIColor.orange
//        navigationController.navigationBar.backgroundColor = .systemBackground
//        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
//        
//        return navigationController
//    }
//    
//    //MARK: - AddCreditCardFactoryProtocol
//    
//    //MARK: - VisionKitFactoryProtocol
//}
