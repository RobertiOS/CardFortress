//
//  CreditCardRepository.swift
//
//
//  Created by Roberto Corrales on 1/7/24.
//

import Foundation

public protocol CreditCardRepository {
    /// Removes credit cards from the repository
    /// - Returns:returns an secure store result
    func removeAllCreditCards() async throws
    /// Adds a credit card to the  the repository
    /// - Parameter card: the card to be added
    /// Removes a credit card
    /// - Parameter id: The id of the credit card
    func removeCreditCard(id: UUID) async throws
    /// Adds a credit card to the  the repository
    /// - Parameter card: the card to be added
    func addCreditCard(_ creditCard: DomainCreditCard) async throws
    /// Returns a credit card  from the repository
    /// - Parameter identifier: The identifier of the credit card (UUID)
    /// - Returns: a credit card
    func getCreditCard(identifier: UUID) async throws -> DomainCreditCard
    /// Returns all credit cards from the repository
    /// - Returns: Array of credit cards
    func getAllCreditCards() async throws -> [DomainCreditCard]
    /// Returns the Favorite credit card from the repository
    /// - Returns: A credit card marked as favorite
    func getFavoriteCreditCard() async throws -> DomainCreditCard?
}
