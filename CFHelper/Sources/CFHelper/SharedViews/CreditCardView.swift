//
//  CreditCardView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/2/23.
//

import SwiftUI

public struct CreditCardView: View {
    
    private struct Constants {
        static let fontName = "Credit Card"
        static let copyImage = "CopyImage"
        static let chipImage = "chip"
    }
    
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cfPurple)
                VStack(spacing:5) {
                    HStack {
                        Text(viewModel.bankName)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                        Spacer()
                    }
                    
                    HStack {
                        Image(Constants.chipImage)
                            .resizable()
                        .frame(width: 55, height: 40)
                        Spacer()
                    }
                    HStack {
                        Text(viewModel.cardNumber)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
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
                        Spacer()
                    }
                }
                .padding()
            }
        }
}

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(viewModel: .init(cardHolderName: "Juan Perez", cardNumber: "1234 2233 2222 2222", date: "11/11", bankName: "Some bank"))
            .frame(width: 300, height: 200)
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
