//
//  CreateUserView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 8/12/23.
//

import SwiftUI

struct CreateUserView: View {
    @StateObject var viewModel: CreateUserViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(viewModel: .init())
    }
}
