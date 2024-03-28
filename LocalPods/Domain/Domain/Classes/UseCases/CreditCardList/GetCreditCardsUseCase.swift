//
//  GetCreditCardsUseCase.swift
//  CardFortress
//
//  Created by Roberto Corrales on 2/19/24.
//

import Foundation

public protocol GetCreditCardsUseCaseProtocol: AnyObject {
    func execute() async throws -> [DomainCreditCard]
}

final public class GetCreditCardsUseCase: GetCreditCardsUseCaseProtocol {
    private let repository: CreditCardRepository
    public init(repository: any CreditCardRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [DomainCreditCard] {
        try await repository.getAllCreditCards()
    }
    
}
