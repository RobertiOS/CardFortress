//
//  CardFortressWidget.swift
//  CardFortressWidget
//
//  Created by Roberto Corrales on 10/4/23.
//

import WidgetKit
import SwiftUI
import CFHelper

struct CardFortressWidgetEntryView : View {
    var entry: CreditCardProvider.Entry
    let viewModel: CreditCardViewModel
    
    init(entry: CreditCardProvider.Entry) {
        self.entry = entry
        
        let creditCard = entry.creditCard
        viewModel = .init(
            cardHolderName: creditCard.cardHolderName,
            cardNumber: creditCard.number,
            date: creditCard.date,
            bankName: creditCard.cardName,
            backgroundColor: .gray,
            cvv: 123,
            showBottomModule: false)
    }
    
    
    var body: some View {
        
        VStack {
            Spacer()
            CreditCardView(
                viewModel: viewModel
            ) {
                if #available(iOSApplicationExtension 17.0, *) {
                    bottomModule
                } else {
                    EmptyView()
                }
            }
            .frame(height: 230)
            .buttonStyle(.bordered)
            .widgetBackground(Color.white.opacity(0.2))
            Spacer()
             
        }
        
    }
    
    @available(iOSApplicationExtension 17.0, *)
    var bottomModule: some View {
        LazyHStack {
            ForEach(viewModel.actionIntents) { intent in
                Button(intent: intent) {
                    Label {
                        Text(intent.buttonName ?? "")
                    } icon: {
                        Image("CopyImage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.black)
                .tint(.green)
            }
        }
        .frame(height: 45)
    }
}

struct CardFortressWidget: Widget {
    let kind: String = "CardFortressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CreditCardProvider()) { entry in
            CardFortressWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

struct CardFortressWidget_Previews: PreviewProvider {
    static var previews: some View {
        CardFortressWidgetEntryView(entry: CreditCardEntry(date: Date(), creditCard: .make()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

