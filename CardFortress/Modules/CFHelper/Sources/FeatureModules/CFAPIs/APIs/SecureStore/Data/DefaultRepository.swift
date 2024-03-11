//
//  DefaultRepository.swift
//
//
//  Created by Roberto Corrales on 2/19/24.
//

import Foundation
import CFDomain

final class DefaultRepository: CreditCardRepository {
    
    func removeCreditCard(id: UUID) async throws {
    }
    
    func removeAllCreditCards() async throws {
    }
    
    func addCreditCard(_ creditCard: DomainCreditCard) async throws {
    }
    
    func getCreditCard(identifier: UUID) async throws -> DomainCreditCard {
        .init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "", isFavorite: true)
    }
    
    func getAllCreditCards() async throws -> [DomainCreditCard] {
        [.init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "", isFavorite: true)]
    }
    
    func getFavoriteCreditCard() async -> DomainCreditCard? {
        .init(identifier: UUID(), number: "", cvv: 1, date: "", cardName: "", cardHolderName: "", notes: "", isFavorite: true)
    }
}
