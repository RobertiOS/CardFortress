//
//  SecureStore+Helpers.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/23/23.
//

import Foundation

enum CreditCardProperties: String, CaseIterable {
    case identifier
    case number
    case cvv
    case date
    case cardName
    case cardHolderName
    
    static var allCasesToString: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

enum SecureStoreResult: Equatable {
    case success
    case failure(SecureStoreFailure)
}

enum SecureStoreFailure: Error, Equatable {
    case itemNotFound
}

struct EncodedCard {
    let identifier: UUID
    let data: Data
}
