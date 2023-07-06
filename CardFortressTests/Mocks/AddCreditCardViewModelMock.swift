//
//  AddCreditCardViewModelMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 6/27/23.
//

import Foundation
@testable import CardFortress
import Combine

final class AddCreditCardViewModelMock: AddCreditCardViewModelProtocol {
    
    
    var creditCardDate: String? = nil
    
    var creditCardName: String? = nil
    
    var creditCardNumber: String? = nil
    
    
    var creditCardHolderName: String? = nil
    
    var shouldUpdateView: PassthroughSubject<Void, Never> = .init()
    
    func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>? {
        Just(AddCreditCardResult.success)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
