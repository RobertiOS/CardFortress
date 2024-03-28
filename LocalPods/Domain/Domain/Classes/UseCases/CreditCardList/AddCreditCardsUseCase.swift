//
//  AddCreditCardsUseCase.swift
//  CardFortress
//
//  Created by Roberto Corrales on 2/19/24.
//

import Foundation

public protocol AddCreditCardsUseCaseProtocol {
    func execute(creditCard: DomainCreditCard) async throws
}

final public class AddCreditCardsUseCase: AddCreditCardsUseCaseProtocol {
    private let repository: CreditCardRepository
    public init(repository: any CreditCardRepository) {
        self.repository = repository
    }
    
    public func execute(creditCard: DomainCreditCard) async throws {
        try await repository.addCreditCard(creditCard)
    }
    
}
