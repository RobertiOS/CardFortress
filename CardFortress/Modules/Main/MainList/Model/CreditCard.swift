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
    var name: String
    
    enum CodingKeys: CodingKey {
        case identifier
        case number
        case cvv
        case date
        case name
    }
}



extension CreditCard {
    init(number: Int, cvv: Int, date: String, name: String) {
        self.init(identifier: UUID(), number: number, cvv: cvv, date: date, name: name)
    }
}

extension CreditCard: Hashable {}
