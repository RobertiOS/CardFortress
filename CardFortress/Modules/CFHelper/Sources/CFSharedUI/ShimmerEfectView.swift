//
//  ShimmerEfectView.swift
//
//
//  Created by Roberto Corrales on 2/20/24.
//

import SwiftUI

struct ShimmerEfectView: View {
    
    private var gradientColors = [
        Color(uiColor: UIColor.systemGray3),
        Color(uiColor: UIColor.systemGray6),
        Color(uiColor: UIColor.systemGray3)
    ]
    
    @State var startPoint: UnitPoint = .init(x: -1, y: 0.5)
    @State var endPoint: UnitPoint = .init(x: 0, y: 0.5)
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: startPoint,
            endPoint: endPoint)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1)
                .repeatForever(autoreverses: false)
            ){
                startPoint = .init(x: 1.5, y: 0.5)
                endPoint = .init(x: 2.5, y: 0.5)
            }
        }
    }
}

#Preview {
    ShimmerEfectView()
}
