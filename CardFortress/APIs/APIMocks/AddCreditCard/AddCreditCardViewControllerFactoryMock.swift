//
//  AddCreditCardViewControllerFactoryMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

import UIKit
import VisionKit

final class AddCreditCardViewControllerFactoryMock: AddCreditCardViewControllerFactoryProtocol {
    func makeAddCardViewController(action: AddCreditCardCoordinator.Action) -> AddCreditCardViewController {
        AddCreditCardViewController(viewModel: .init(service: MockListService()))
    }
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        VisionKitViewControllerMock()
    }
    
}

final class VisionKitViewControllerMock: UIViewController, VisionKitViewControllerProtocol {
    var delegate: VNDocumentCameraViewControllerDelegate?
}
