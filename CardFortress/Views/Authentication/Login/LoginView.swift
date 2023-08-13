//
//  LoginView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/20/23.
//

import SwiftUI

struct LoginView: View {

    //MARK: - properties

    @StateObject var viewModel: ViewModel
    
    //MARK: Views
    
    var body: some View {
        ScrollView {
            VStack {
                topContainerView
                fieldsContainerView
                buttonContainerView
                bottomContainterView
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: .init(colors: [.cfPurple, .white]), startPoint: .top, endPoint: .bottom)
            )
        }
    }
    
    @ViewBuilder
    private var topContainerView: some View {
        Text("Credit Card Fortress")
            .font(.system(size: 40, weight: .semibold))
            .foregroundColor(.white)
        Image("credit-cards")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
        
        Text("Log in")
            .font(.system(size: 35, weight: .semibold))
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    private var fieldsContainerView: some View {
        TextField("your email", text: $viewModel.email)
            .textFieldStyle(
                OutlinedTextFieldStyle(icon: Image(systemName: "person.fill"))
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        SecureField("your password", text: $viewModel.password)
            .textFieldStyle(
                OutlinedTextFieldStyle(icon: Image(systemName: "lock.fill"))
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        
        if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 30))
                .background(.red)
                .cornerRadius(10)
            
        }
    }
    
    @ViewBuilder
    private var buttonContainerView: some View {
        Button {
            Task {
                await viewModel.login()
            }
        } label: {
                VStack {
                    if viewModel.isloading {
                        ProgressView()
                    } else {
                        Text("Login")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(viewModel.isloading ? Color.cfPurple.opacity(0.5) : Color.cfPurple)
                )
        }
        .disabled(viewModel.isloading)
        Button {
            //TODO: handle button action
        } label: {
            
            Text("Sign Up")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.cfPurple)
                .font(.system(size: 20, weight: .semibold))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.cfPurple, lineWidth: 2)
                )
        }
    }
    
    @ViewBuilder
    private var bottomContainterView: some View {
        Text("or connect with")
            .padding(.top)
        
        HStack {
            Button {
                //TODO: - Handle button action
            } label: {
                Image("facebook")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            }
            .padding(.trailing)

            Button {
                //TODO: - Handle button action
            } label: {
                Image("google")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(.top)
        .frame(height: 50)
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init())
    }
}
