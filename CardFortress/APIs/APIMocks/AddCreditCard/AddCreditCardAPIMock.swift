//
//  AddCreditCardAPIMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/17/23.
//

final class AddCreditCardAPIMock: AddCreditCardAPI {
    var coordinatorFactory: AddCreditCardCoordinatorFactoryProtocol = AddCreditCardCoordinatorFactoryMock()
}
