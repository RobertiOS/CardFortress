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
        return  [.init(
            identifier: UUID(),
            number: "1234",
            cvv: 123,
            date: "11/11",
            cardName: "bac",
            cardHolderName: "Roberto",
            notes: "none",
            isFavorite: true
        ),
                 .init(
                    identifier: UUID(),
                    number: "1234",
                    cvv: 123,
                    date: "11/11",
                    cardName: "bac",
                    cardHolderName: "Roberto",
                    notes: "none",
                    isFavorite: true
                 ),
                 .init(
                    identifier: UUID(),
                    number: "1234",
                    cvv: 123,
                    date: "11/11",
                    cardName: "bac",
                    cardHolderName: "Roberto",
                    notes: "none",
                    isFavorite: true
                 )]
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

final public class GetCreditCardUseCaseMock: GetCreditCardUseCaseProtocol {
    public init() { }
    public func execute(
        identifier: UUID
    ) async throws -> DomainCreditCard {
        .init(
            identifier: UUID(),
            number: "1234",
            cvv: 123,
            date: "11/11",
            cardName: "bac",
            cardHolderName: "Roberto",
            notes: "none",
            isFavorite: true
        )
    }
}
