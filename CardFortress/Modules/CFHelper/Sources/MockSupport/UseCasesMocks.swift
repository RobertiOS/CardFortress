//
//  GetCreditCardsUseCaseMock.swift
//
//
//  Created by Roberto Corrales on 3/11/24.
//

import Foundation
import CFDomain

final public class GetCreditCardsUseCaseMock: GetCreditCardsUseCaseProtocol {
    public init() { }
    public func execute() async throws -> [DomainCreditCard] {
        return []
    }
}

final public class RemoveCreditCardUseCaseMock: RemoveCreditCardUseCaseProtocol {
    public init() { }
    public func execute(identifier: UUID) async throws -> [DomainCreditCard] {
       []
    }
}

final public class AddCreditCardsUseCaseMock: AddCreditCardsUseCaseProtocol {
    public init() { }
    public func execute(creditCard: DomainCreditCard) async throws {
    }
}
