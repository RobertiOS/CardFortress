//
//  BackgroundCreditCard.swift
//
//
//  Created by Roberto Corrales on 12/30/23.
//

import CoreGraphics
import SwiftUI

struct BackgroundCreditCard: View {
    
    let gradient: LinearGradient
    let gradient2: LinearGradient = .linearGradient(stops: [.init(color: .red, location: 0), .init(color: .yellow, location: 1)], startPoint: .bottom, endPoint: .top)
    let gradient3: LinearGradient = .linearGradient(stops: [.init(color: .red, location: 0), .init(color: .green, location: 1)], startPoint: .bottom, endPoint: .top)
    
    init(gradient: LinearGradient) {
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            BackgroundShape(gradient: gradient3)
                .transformEffect(.init(scaleX: 1.2, y: 1.3))
                .transformEffect(.init(translationX: -1, y: -64))
            BackgroundShape(gradient: gradient2)
                .transformEffect(.init(scaleX: 1.1, y: 1.2))
                .transformEffect(.init(translationX: -1, y: -44))
            BackgroundShape(gradient: gradient)
        }
        .clipped()
    }
}


private struct BackgroundShape: View {
    
    let gradient: LinearGradient
    
    internal init(gradient: LinearGradient) {
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            
            GeometryReader { proxy in
                let computedHeight = proxy.size.height
                let fullWidth = proxy.size.width
                
                Path { path in
                    path.move(to: .init(x: 0, y: computedHeight))
                    path.addLine(to: .init(x: fullWidth - 20, y: computedHeight))
                    path.addCurve(to: .init(x: fullWidth - 70, y: computedHeight - 40), control1: .init(x: fullWidth , y: computedHeight - 40), control2: .init(x: fullWidth - 40, y: computedHeight - 40))
                    path.addCurve(to: .init(x: fullWidth / 2.5, y: computedHeight / 1.5), control1: .init(x: fullWidth / 2.5, y: computedHeight / 1.2), control2: .init(x: fullWidth / 2.5, y: computedHeight / 1.5))
                    path.addCurve(to: .init(x: 0, y: computedHeight / 1.9), control1: .init(x: fullWidth / 2.5, y: computedHeight / 2.5), control2: .init(x: 0, y: computedHeight / 1.9))
                }
                .fill(gradient)
            }
        }
    }
}

#Preview {
    BackgroundCreditCard(gradient: .linearGradient(stops: [.init(color: .red, location: 0), .init(color: .blue, location: 1)], startPoint: .bottom, endPoint: .top))
        .frame(width: 350, height: 240)
        .previewLayout(.fixed(width: 500, height: 600))
}


