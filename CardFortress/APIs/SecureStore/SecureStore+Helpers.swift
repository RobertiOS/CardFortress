//
//  SecureStore+Helpers.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/23/23.
//

import Foundation

enum CreditCardProperty: String, CaseIterable {
    case identifier
    case number
    case cvv
    case date
    case cardName
    case cardHolderName
}
enum SecureStoreResult: Equatable {
    case success
    case failure(SecureStoreFailure)
}

enum SecureStoreFailure: Error, Equatable {
    case itemNotFound
}
