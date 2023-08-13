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
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Sign up")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.cfPurple)
                    Spacer()
                }
                .padding(.vertical, 50)
                
                textFieldsContainer
                
                Button {
                    Task {
                        await viewModel.createUser()
                    }
                } label: {
                    
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .semibold))
                        .background(.cyan)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.cfPurple, lineWidth: 2)
                        ).background()
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var textFieldsContainer: some View {
        Text("First name")
            .foregroundColor(.gray)
        TextField("Your first name", text: $viewModel.name)
            .textFieldStyle(
                OutlinedTextFieldStyle(
                    icon: Image(systemName: "person.fill"),
                    color: .cfPurple
                )
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        Text("Last name")
            .foregroundColor(.gray)
        TextField("Last Name", text: $viewModel.lastName)
            .textFieldStyle(
                OutlinedTextFieldStyle(
                    icon: Image(systemName: "person.fill"),
                    color: .cfPurple
                )
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        Text("Email")
            .foregroundColor(.gray)
        TextField("your email", text: $viewModel.email)
            .textFieldStyle(
                OutlinedTextFieldStyle(
                    icon: Image(systemName: "person.fill"),
                    color: .cfPurple
                )
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        Text("Password")
            .foregroundColor(.gray)
        SecureField("your password", text: $viewModel.password)
            .textFieldStyle(
                OutlinedTextFieldStyle(
                    icon: Image(systemName: "lock.fill"),
                    color: .cfPurple
                )
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        Text("Confirm Password")
            .foregroundColor(.gray)
        SecureField("Confirm password", text: $viewModel.confirmationPassword)
            .textFieldStyle(
                OutlinedTextFieldStyle(
                    icon: Image(systemName: "lock.fill"),
                    color: .cfPurple
                )
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(viewModel: .init())
    }
}
