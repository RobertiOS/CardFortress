//
//  TextFieldStyles.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/22/23.
//

import SwiftUI

struct OutlinedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color(UIColor.white))
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.white), lineWidth: 2)
        }
    }
}
