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
    
    func makeVNDocumentCameraViewController() -> VNDocumentCameraViewController {
        VNDocumentCameraViewController()
    }
}


final class CardListViewControllerMock: UIViewController, CardListViewControllerProtocol {
}

final class AddCreditCardViewControllerMock: UIViewController ,AddCreditCardViewControllerProtocol {
    var viewModel: AddCreditCardViewModelProtocol = AddCreditCardViewModelMock()
    var delegate: AddCreditCardCoordinatorDelegate?
}
