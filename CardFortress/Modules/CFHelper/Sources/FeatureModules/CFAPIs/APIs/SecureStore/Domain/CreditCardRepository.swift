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
    @discardableResult
    func removeAllCreditCards() async throws -> CreditCardsRepositoryResult
    /// Adds a credit card to the  the repository
    /// - Parameter card: the card to be added
    /// - Returns: returns an secure store result
    ///
    @discardableResult
    /// Removes a credit card
    /// - Parameter id: The id of the credit card
    /// - Returns: a result indicating if the card was deleted succesfuly
    func removeCreditCard(id: UUID) async throws -> CreditCardsRepositoryResult
    /// Adds a credit card to the  the repository
    /// - Parameter card: the card to be added
    /// - Returns: returns an secure store result
    @discardableResult
    func addCreditCard(_ creditCard: SecureStoreCreditCard) async throws -> CreditCardsRepositoryResult
    /// Returns a credit card  from the repository
    /// - Parameter identifier: The identifier of the credit card (UUID)
    /// - Returns: optional credit card
    func getCreditCard(identifier: UUID) async throws -> DomainCreditCard?
    /// Returns all credit cards from the repository
    /// - Returns: Array of credit cards
    func getAllCreditCards() async throws -> [DomainCreditCard]
    /// Returns the Favorite credit card from the repository
    /// - Returns: An optional credit
    func getFavoriteCreditCard() async -> DomainCreditCard?
}

public enum CreditCardsRepositoryResult {
    case success
    case failure
}
