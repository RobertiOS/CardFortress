//
//  TextFieldStyles.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import SwiftUI
import CFSharedResources

struct OutlinedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    @State var color: Color = CFSharedColors.purple1.swiftUIColor
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(color)
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(color, lineWidth: 2)
        }
    }
}
