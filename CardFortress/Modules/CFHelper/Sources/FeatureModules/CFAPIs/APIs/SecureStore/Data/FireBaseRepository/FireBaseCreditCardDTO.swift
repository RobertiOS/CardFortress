//
//  FireBaseCreditCardDTO.swift
//
//
//  Created by Roberto Corrales on 3/11/24.
//

import Foundation

struct FireBaseCreditCardDTO: Decodable {
    public let identifier: UUID
    public let number: String
    public let cvv: Int
    public let date: String
    public let cardName: String
    public let cardHolderName: String
    public let notes: String
    public let isFavorite: Bool
    
    public init(
        identifier: UUID,
        number: String,
        cvv: Int,
        date: String,
        cardName: String,
        cardHolderName: String,
        notes: String,
        isFavorite: Bool
    ) {
        self.identifier = identifier
        self.number = number
        self.cvv = cvv
        self.date = date
        self.cardName = cardName
        self.cardHolderName = cardHolderName
        self.notes = notes
        self.isFavorite = isFavorite
    }
    
    
    func toDomain() -> DomainCreditCard {
        .init(
            identifier: identifier,
            number: number,
            cvv: cvv,
            date: date,
            cardName: cardName,
            cardHolderName: cardHolderName,
            notes: notes,
            isFavorite: isFavorite
        )
    }
}

