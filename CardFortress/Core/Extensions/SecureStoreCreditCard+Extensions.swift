//
//  SecureStoreCreditCard+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/3/23.
//

import Foundation
import Data

extension SecureStoreCreditCard {
    init(creditCard: CreditCard) {
        self.init(identifier: creditCard.identifier, number: creditCard.number, cvv: creditCard.cvv, date: creditCard.date, cardName: creditCard.cardName, cardHolderName: creditCard.cardHolderName)
    }
}

extension CreditCard {
    init(creditCard: SecureStoreCreditCard) {
        self.init(identifier: creditCard.identifier, number: creditCard.number, cvv: creditCard.cvv, date: creditCard.date, cardName: creditCard.cardName, cardHolderName: creditCard.cardHolderName)
    }
}
