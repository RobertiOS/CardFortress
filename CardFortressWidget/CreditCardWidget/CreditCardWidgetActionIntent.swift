//
//  CreditCardWidgetActionIntent.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/15/23.
//

import Foundation
import CFHelper
import WidgetKit
import AppIntents

enum CardData: CaseIterable, Identifiable {
    public var id: Int {
        self.hashValue
    }
    
    case cvv
    case number
    case date
    
    var buttonName: String {
        switch self {
        case .cvv:
            "CVV"
        case .number:
            "Number"
        case .date:
            "Date"
        }
    }
}

struct WidgetActionIntent: AppIntent, Identifiable  {
    
    private let cardsStorage = SecureStore()
    
    var id = UUID()
    static var title: LocalizedStringResource = "copy to clipboard"
    
    @Parameter(title: "Task ID")
    var buttonName: String?
    
    init(buttonName: String) {
        self.buttonName = buttonName
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        await copyToClipboard()
        return .result()
    }
    
    func copyToClipboard() async {
        let creditCard = await cardsStorage.getFavoriteCreditCard()
        let value: String
        switch buttonName {
        case "CVV":
            value = String(creditCard?.cvv ?? 0)
        case "Number":
            value = String(creditCard?.number ?? 0)
        case "Date":
            value = creditCard?.date ?? ""
        default:
            value = ""
        }
//        UIPasteboard.general.string = value
    }
}


extension CreditCardViewModel {
    // MARK: - Helpers
    
    var actionIntents: [WidgetActionIntent] {
        CardData.allCases.map { item in
            WidgetActionIntent(buttonName: item.buttonName)
        }
    }
}
