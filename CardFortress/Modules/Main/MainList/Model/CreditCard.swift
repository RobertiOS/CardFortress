//
//  CreditCard.swift
//  CardFortress
//
//  Created by Roberto Corrales on 30/04/23.
//

import Foundation

struct CreditCard: Decodable {
    /// unique identifier for the cards
    var identifier: UUID
    var number: Int
    var cvv: Int
    var date: String
    var cardName: String
    var cardHolderName: String
}



extension CreditCard {
    init(number: Int, cvv: Int, date: String, cardName: String, cardHolderName: String) {
        self.init(identifier: UUID(),
                  number: number,
                  cvv: cvv,
                  date: date,
                  cardName: cardName,
                  cardHolderName: cardHolderName)
    }
}

extension CreditCard: Hashable {}
