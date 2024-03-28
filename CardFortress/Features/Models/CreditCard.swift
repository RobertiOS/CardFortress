//
//  CreditCard.swift
//  CardFortress
//
//  Created by Roberto Corrales on 30/04/23.
//

import Foundation

struct CreditCard: Decodable {
    /// unique identifier for the cards
    let identifier: UUID
    let number: String
    let cvv: Int
    let date: String
    let cardName: String
    let cardHolderName: String
}



extension CreditCard {
    init(number: String, cvv: Int, date: String, cardName: String, cardHolderName: String) {
        self.init(identifier: UUID(),
                  number: number,
                  cvv: cvv,
                  date: date,
                  cardName: cardName,
                  cardHolderName: cardHolderName)
    }
}

extension CreditCard: Hashable {}

extension CreditCard {
    static func make(
        number: String = "111",
        cvv: Int = 111,
        date: String = "12221",
        cardName: String = "Visa",
        cardHolderName: String = "Juan Perez"
    ) -> Self {
        CreditCard(number: number, cvv: cvv, date: date, cardName: cardName, cardHolderName: cardHolderName)
    }
}
