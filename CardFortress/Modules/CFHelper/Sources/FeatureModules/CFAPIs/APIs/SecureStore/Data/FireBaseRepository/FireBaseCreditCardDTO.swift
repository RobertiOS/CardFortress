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
    public let cardHolderName: String?
    public let notes: String?
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
            cardHolderName: cardHolderName ?? "",
            notes: notes ?? "",
            isFavorite: isFavorite
        )
    }
    
    enum CodingKeys: CodingKey {
        case identifier
        case number
        case cvv
        case date
        case cardName
        case cardHolderName
        case notes
        case isFavorite
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uuidString = try container.decode(String.self, forKey: .identifier)
        guard let uuid = UUID(uuidString: uuidString) else { throw NSError(domain: "FireBaseCreditCardDTO", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while decoding credit card id"])}
        self.identifier = uuid
        self.number = try container.decode(String.self, forKey: .number)
        self.cvv = try container.decode(Int.self, forKey: .cvv)
        self.date = try container.decode(String.self, forKey: .date)
        self.cardName = try container.decode(String.self, forKey: .cardName)
        self.cardHolderName = try container.decodeIfPresent(String.self, forKey: .cardHolderName)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}

