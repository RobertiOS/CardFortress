//
//  VisionKitCoordinator.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/17/23.
//

import UIKit
import VisionKit
import Vision

enum VisionKitResult {
    case successfulScan(CreditCard?)
    case userCancelled
    case withError(Error)
}

protocol VisionKitCoordinating: Coordinator<VisionKitResult>, NavigationCoordinator {
    
}

final class VisionKitCoordinator: Coordinator<VisionKitResult>, VisionKitCoordinating {
    
    var navigationController: UINavigationController
    private let factory: VisionKitFactoryProtocol
    private let imageParser: ImageParserProtocol
    
    init(factory: VisionKitFactoryProtocol,
         navigationController: UINavigationController,
         imageParser: ImageParserProtocol = ImageParser()) {
        self.factory = factory
        self.navigationController = navigationController
        self.imageParser = imageParser
    }
    
    override func start() {
        super.start()
        let visionViewController = factory.makeVNDocumentCameraViewController()
        visionViewController.delegate = self
        navigateTo(visionViewController, presentationStyle: .present())
    }
}

extension VisionKitCoordinator: VNDocumentCameraViewControllerDelegate {
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Document camera view controller did finish with ", scan)
        let image = scan.imageOfPage(at: 0)
        Task(priority: .userInitiated) {
            let creditCard = await imageParser.mapUIImageToCreditCard(image: image)
            finish(.successfulScan(creditCard))
        }
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        finish(.userCancelled)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        
        #if targetEnvironment(simulator)
        Task {
            let image = UIImage(named: "creditCardMock")
            let creditCard = await imageParser.mapUIImageToCreditCard(image: image)
            finish(.successfulScan(creditCard))
           
        }
        controller.dismiss(animated: true)

        #else
        
        finish(.withError(error))
        controller.dismiss(animated: true)

        #endif
        
    }
}
