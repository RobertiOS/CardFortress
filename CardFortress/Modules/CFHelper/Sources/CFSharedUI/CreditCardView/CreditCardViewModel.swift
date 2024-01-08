//
//  CreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/2/23.
//

import AppIntents
import SwiftUI
import CFAPIs
import CFSharedResources

final public class CreditCardViewModel: ObservableObject {
    //MARK: -  Public properties
    @Published public var cardHolderName: String
    @Published public var cardNumber: String {
        didSet {
            formatedCardNumber = getformatedTextTextForCreditCardNumber(cardNumber: cardNumber)
        }
    }
    @Published public var date: String
    @Published public var bankName: String
    @Published public var backgroundColor: Color
    
    
    //MARK: -  Private properties
    @Published private(set) var formatedCardNumber: AttributedString = ""
    @Published private(set) var cardTypeIconImage: Image?
    public var cvv: Int
    @Published public var showBottomModule: Bool
    
    public init(
        cardHolderName: String = "",
        cardNumber: String = "",
        date: String = "",
        bankName: String = "",
        backgroundColor: Color = .cfPurple,
        cvv: Int = 0,
        showBottomModule: Bool = false
    ) {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.date = date
        self.bankName = bankName
        self.backgroundColor = backgroundColor
        self.cvv = cvv
        self.showBottomModule = showBottomModule
        self.formatedCardNumber = getformatedTextTextForCreditCardNumber(cardNumber: cardNumber)
        updateCardImageType()
    }
    
    private func getformatedTextTextForCreditCardNumber(cardNumber: String) -> AttributedString {
        var formatedText = ""
        for (i, c) in cardNumber.enumerated() {
            if i > 0 && i % 4 == 0 {
                formatedText += " "
            }
            formatedText.append(c)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.kern: 2,
            //                NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: 14.0)!
        ]
        let attributedText = NSAttributedString(string: formatedText, attributes: attributes)
        
        return AttributedString(attributedText)
    }
    
    
    func updateCardImageType() {
        let validator = CreditCardValidator(String(cardNumber))
        cardTypeIconImage = validator.type?.image
    }
}
