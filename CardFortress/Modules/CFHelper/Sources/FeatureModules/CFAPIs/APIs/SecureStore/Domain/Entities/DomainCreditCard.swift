//
//  DomainCreditCard.swift
//
//
//  Created by Roberto Corrales on 1/7/24.
//

import Foundation

public struct DomainCreditCard {
    public let identifier: UUID
    public let number: String
    public let cvv: Int
    public let date: String
    public let cardName: String
    public let cardHolderName: String
    public let notes: String
    
    public init(identifier: UUID, number: String, cvv: Int, date: String, cardName: String, cardHolderName: String, notes: String) {
        self.identifier = identifier
        self.number = number
        self.cvv = cvv
        self.date = date
        self.cardName = cardName
        self.cardHolderName = cardHolderName
        self.notes = notes
    }
}
