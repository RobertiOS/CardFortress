//
//  CreditCardView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/2/23.
//

import SwiftUI
import CFSharedResources

public struct CreditCardView<Content : View>: View {
    
    @ObservedObject public var viewModel: CreditCardViewModel
    let bottomView: Content
    
    public init(
        viewModel: CreditCardViewModel,
        @ViewBuilder bottomView: (() -> Content) = { EmptyView() }
    ) {
        self.viewModel = viewModel
        self.bottomView = bottomView()
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.linearGradient(stops: [.init(color: CFSharedColors.purple3.swiftUIColor, location: 0), .init(color: CFSharedColors.purple4.swiftUIColor, location: 1)], startPoint: .bottom, endPoint: .top))
                BackgroundCreditCard(gradient: .linearGradient(stops: [.init(color: CFSharedColors.purple1.swiftUIColor, location: 0), .init(color: CFSharedColors.purple2.swiftUIColor, location: 1)], startPoint: .bottom, endPoint: .top))
                VStack(spacing:5) {
                    HStack {
                        Text(viewModel.bankName)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                        Spacer()
                        if let image = viewModel.cardTypeIconImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                        }
                    }
                    
                    HStack {
                        SharedImages.chip.swiftUIImage
                            .resizable()
                            .frame(width: 55, height: 40)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(viewModel.formatedCardNumber)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .layoutPriority(1)
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            Text("Valid")
                            Text("Tru")
                        }
                        .foregroundColor(.white)
                        .font(.caption2)
                        Text(viewModel.date)
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.leading, 40)
                    HStack {
                        Text("CARD HOLDER")
                            .foregroundColor(.white)
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Text(viewModel.cardHolderName)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                        Spacer()
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 350, height: 240)
            if viewModel.showBottomModule {
                bottomView
            }
        }
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(viewModel: .init(
            cardHolderName: "Juan Perez",
            cardNumber: "4098480016653433222",
            date: "11/11",
            bankName: "Some bank",
            backgroundColor: .gray,
            cvv: 123,
            showBottomModule: true))
        .previewLayout(.fixed(width: 500, height: 600))
    }
}
