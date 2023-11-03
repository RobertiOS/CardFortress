//
//  SecureStoreCreditCard.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/10/23.
//

import Foundation

public struct SecureStoreCreditCard: Decodable {
    /// unique identifier for the cards
    public let identifier: UUID
    public let number: Int
    public let cvv: Int
    public let date: String
    public let cardName: String
    public let cardHolderName: String
    
    public init(identifier: UUID, number: Int, cvv: Int, date: String, cardName: String, cardHolderName: String) {
        self.identifier = identifier
        self.number = number
        self.cvv = cvv
        self.date = date
        self.cardName = cardName
        self.cardHolderName = cardHolderName
    }
}



extension SecureStoreCreditCard: Hashable {
    public init(number: Int, cvv: Int, date: String, cardName: String, cardHolderName: String) {
        self.init(identifier: UUID(),
                  number: number,
                  cvv: cvv,
                  date: date,
                  cardName: cardName,
                  cardHolderName: cardHolderName)
    }
    
    public static func make() -> Self {
        SecureStoreCreditCard(number: 111, cvv: 111, date: "12221", cardName: "Visa", cardHolderName: "Juan Perez")
    }
}

