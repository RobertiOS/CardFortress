//
//  GetCreditCardUseCase.swift
//  CardFortress
//
//  Created by Roberto Corrales on 2/19/24.
//

import Foundation

public protocol GetCreditCardUseCaseProtocol {
    func execute(identifier: UUID) async throws -> DomainCreditCard
}

final public class GetCreditCardUseCase: GetCreditCardUseCaseProtocol {
    private let repository: CreditCardRepository
    public init(repository: any CreditCardRepository) {
        self.repository = repository
    }
    
    public func execute(identifier: UUID) async throws -> DomainCreditCard {
        try await repository.getCreditCard(identifier: identifier)
    }
    
}
