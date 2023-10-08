//
//  CreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/2/23.
//

import Foundation

public extension CreditCardView {
    final class ViewModel: ObservableObject {
        @Published var cardHolderName: String
        @Published var cardNumber: String
        @Published var date: String
        @Published var bankName: String
        
        public init(cardHolderName: String, cardNumber: String, date: String, bankName: String) {
            self.cardHolderName = cardHolderName
            self.cardNumber = cardNumber
            self.date = date
            self.bankName = bankName
        }
    }
}
