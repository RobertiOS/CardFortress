//
//  FireBaseRepository.swift
//
//
//  Created by Roberto Corrales on 3/10/24.
//

import Foundation
import FirebaseFirestore

final class FireBaseRepository: CreditCardRepository {
    
    private let db = Firestore.firestore()
    private let decoder = JSONDecoder()
    
    func removeAllCreditCards() async throws {
        
    }
    
    func removeCreditCard(id: UUID) async throws {
        
    }
    
    func addCreditCard(_ creditCard: DomainCreditCard) async throws {
        
        do {
            try await getCreditCardsCollection()
                .document(creditCard.identifier.uuidString)
                .setData(["number": creditCard.number,
                          "cvv": creditCard.cvv,
                          "date": creditCard.date,
                          "cardName": creditCard.cardName,
                          "cardHolderName": creditCard.cardHolderName,
                          "notes": creditCard.notes,],
                         merge: true)
            /// merge: true in case the document already exitsts
        } catch {
            throw NSError(domain: "FireBaseRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while adding/ editing credit card"])
        }
    }
    
    func getCreditCard(identifier: UUID) async throws -> DomainCreditCard {
        do {
            return try await getCreditCardsCollection()
                .document(identifier.uuidString)
                .getDocument(source: .default)
                .data(as: FireBaseCreditCardDTO.self)
                .toDomain()
        } catch {
            throw NSError(domain: "FireBaseRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while getting the credit card"])
        }
    }
    
    func getAllCreditCards() async throws -> [DomainCreditCard] {
        do {
            let creditCardsDTOs = try await getCreditCardsCollection()
                .getDocuments(source: .default)
                .documents.map( { try $0.data(as: FireBaseCreditCardDTO.self)})
            
            return creditCardsDTOs.map { $0.toDomain() }
        } catch {
            throw NSError(domain: "FireBaseRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while getting credit cards"])
        }
    }
    
    func getFavoriteCreditCard() async throws -> DomainCreditCard? {
        do {
            return try await getCreditCardsCollection()
                .whereField("isFavorite", isEqualTo: true)
                .getDocuments(source: .default)
                .documents
                .first?
                .data(as: FireBaseCreditCardDTO.self)
                .toDomain()
        } catch {
            throw NSError(domain: "FireBaseRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while getting credit cards"])
        }
    }
    
    private func getCreditCardsCollection() -> CollectionReference {
        db.collection(Collections.creditCards.rawValue)
    }
}

fileprivate enum Collections: String {
    case creditCards
}
