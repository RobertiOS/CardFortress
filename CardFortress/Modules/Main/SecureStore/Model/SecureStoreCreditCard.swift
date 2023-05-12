//
//  SecureStoreCreditCard.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/10/23.
//

import Foundation

struct SecureStoreCreditCard: Decodable {
    /// unique identifier for the cards
    let identifier: UUID
    let number: Int
    let cvv: Int
    let date: String
    let cardName: String
    let cardHolderName: String
}



extension SecureStoreCreditCard {
    init(number: Int, cvv: Int, date: String, cardName: String, cardHolderName: String) {
        self.init(identifier: UUID(),
                  number: number,
                  cvv: cvv,
                  date: date,
                  cardName: cardName,
                  cardHolderName: cardHolderName)
    }
}

extension SecureStoreCreditCard: Hashable {}
