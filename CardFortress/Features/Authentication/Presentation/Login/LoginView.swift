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
        }
        .background(
            LinearGradient(gradient: .init(colors: [Color(uiColor: CFColors.purple.color), .white]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    @ViewBuilder
    private var topContainerView: some View {
        Text(LocalizableString.creditCardFortressHeader)
            .font(.system(size: 40, weight: .semibold))
            .foregroundColor(.white)
        Image("credit-cards")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
        
        Text(LocalizableString.login)
            .font(.system(size: 35, weight: .semibold))
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    private var fieldsContainerView: some View {
        TextField(LocalizableString.yourEmail, text: $viewModel.email)
            .textFieldStyle(
                OutlinedTextFieldStyle(icon: Image(systemName: "person.fill"))
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        SecureField(LocalizableString.yourPassword, text: $viewModel.password)
            .textFieldStyle(
                OutlinedTextFieldStyle(icon: Image(systemName: "lock.fill"))
            )
            .font(.system(size: 20))
            .padding(.bottom, 10)
        
        HStack {
            Text(LocalizableString.rememberMe)
                .foregroundColor(.white)
            if #available(iOS 17.0, *) {
                Button {
                    viewModel.isRememberMeEnabled.toggle()
                } label: {
                    Image(systemName: viewModel.isRememberMeEnabled ? "checkmark.square" : "square")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        
        
        if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 30))
                .background(.red)
                .cornerRadius(10)
            
        }
    }
    
    @ViewBuilder
    private var buttonContainerView: some View {
        HStack {
            Button {
                Task {
                    await viewModel.login()
                }
            } label: {
                VStack {
                    if viewModel.isloading {
                        ProgressView()
                    } else {
                        Text(LocalizableString.login)
                            .foregroundColor(Color.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(viewModel.isloading ? CFColors.purple.swiftUIColor.opacity(0.5) : CFColors.purple.swiftUIColor)
                )
            }
            .disabled(viewModel.isloading)
            
            Button {
                Task {
                    await viewModel.loginWithBiometrics()
                }
            } label: {
                VStack {
                    viewModel.biometricsImage?
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                        .tint(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(viewModel.isloading ? CFColors.purple.swiftUIColor.opacity(0.5) : CFColors.purple.swiftUIColor)
                )
            }
            .disabled(viewModel.isloading)
        }
        Button {
            viewModel.startCreateUser()
        } label: {
            Text(LocalizableString.signUp)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(CFColors.purple.swiftUIColor)
                .font(.system(size: 20, weight: .semibold))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(CFColors.purple.swiftUIColor, lineWidth: 2)
                )
        }
    }
    
    @ViewBuilder
    private var bottomContainterView: some View {
        Text(LocalizableString.orConnectWith)
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
