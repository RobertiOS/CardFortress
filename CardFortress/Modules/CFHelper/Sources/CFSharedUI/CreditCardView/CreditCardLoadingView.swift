//
//  CreditCardLoadingView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 10/2/23.
//

import SwiftUI
import CFSharedResources

public struct CreditCardLoadingView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.10))

                ShimmerEfectView()
                    .mask(PlaceHolderView())
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(width: 350, height: 240)
    }
}

struct CreditCardLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardLoadingView()
        .frame(width: 350, height: 240)
        .previewLayout(.fixed(width: 500, height: 600))
    }
}

struct PlaceHolderView: View {
    let pillsColor: Color = Color.gray.opacity(0.5)
    var body: some View {
        VStack(spacing:5) {
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(height: 35)
            }
            
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(width: 100, height: 39)
                Spacer()
            }
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(height: 25)
                
            }
            
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(width: 100, height: 39)
                
                Spacer()
            }
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(width: 100,height: 20)
                Spacer()
            }
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(pillsColor)
                    .frame(height: 30)
            }
        }
        .padding()
    }
}
