//
//  CreditCardWidgetProvider.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/15/23.
//

import Foundation
import WidgetKit
import CFAPIs

struct CreditCardProvider: TimelineProvider {
    
    let secureStoreAPI = SecureStore()
    func placeholder(in context: Context) -> CreditCardEntry {
        CreditCardEntry(date: Date(), creditCard: .make())
    }

    func getSnapshot(in context: Context, completion: @escaping (CreditCardEntry) -> ()) {
        Task {
            let card = await secureStoreAPI.getFavoriteCreditCard()
            let entry = CreditCardEntry(date: Date(), creditCard: card ?? .make())
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CreditCardEntry>) -> ()) {
        Task {
            let card = await secureStoreAPI.getFavoriteCreditCard()
            let entry = CreditCardEntry(date: Date(), creditCard: card ?? .make())
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
            
        }
    }
}

struct CreditCardEntry: TimelineEntry {
    let date: Date
    let creditCard: SecureStoreCreditCard
    
    init(date: Date, creditCard: SecureStoreCreditCard) {
        self.date = date
        self.creditCard = creditCard
    }
}
