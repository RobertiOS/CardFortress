//
//  DefaultRepository.swift
//
//
//  Created by Roberto Corrales on 2/19/24.
//

import Foundation

final class DefaultRepository: CreditCardRepository {
    func removeCreditCard(id: UUID) async throws -> CreditCardsRepositoryResult {
        .success
    }
    
    func removeAllCreditCards() async throws -> CreditCardsRepositoryResult {
        .success
    }
    
    func addCreditCard(_ creditCard: SecureStoreCreditCard) async throws -> CreditCardsRepositoryResult {
        .success
    }
    
    func getCreditCard(identifier: UUID) async throws -> DomainCreditCard? {
        .init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "")
    }
    
    func getAllCreditCards() async throws -> [DomainCreditCard] {
        [.init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "")]
    }
    
    func getFavoriteCreditCard() async -> DomainCreditCard? {
        .init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "")
    }
}
