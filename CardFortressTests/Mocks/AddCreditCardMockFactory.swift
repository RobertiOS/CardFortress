//
//  AddCreditCardMockFactory.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 6/27/23.
//

import Foundation
import VisionKit
@testable import CardFortress

final class AddCreditCardMockFactory: CreditCardListFactoryProtocol,
                                      AddCreditCardFactoryProtocol,
                                      VisionKitFactoryProtocol {
    func makeMainListViewController() -> CardListViewControllerProtocol {
        CardListViewControllerMock()
    }
    
    func makeAddCardViewController() -> AddCreditCardViewControllerProtocol {
        AddCreditCardViewControllerMock()
    }
    
    func makeVNDocumentCameraViewController() -> VisionKitViewControllerProtocol {
        MockVisionVC()
    }
}


final class CardListViewControllerMock: UIViewController, CardListViewControllerProtocol {

}

final class AddCreditCardViewControllerMock: UIViewController ,AddCreditCardViewControllerProtocol {
    var viewModel: AddCreditCardViewController.ViewModel = .init(service: MockListService())
    var delegate: AddCreditCardCoordinatorDelegate?
}

final class MockVisionVC: UIViewController, VisionKitViewControllerProtocol {
    var delegate: VNDocumentCameraViewControllerDelegate?
}
