//
//  LoginViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/20/23.
//

import Foundation
import SwiftUI

protocol LoginViewDelegate: AnyObject {
    func login(email: String, password: String) async -> AuthenticationResult?
    func loginWithBiometrics() async -> AuthenticationResult?
    func startCreateUser()
}

extension LoginView {
    
    final class ViewModel: ObservableObject {
        
        //MARK: - Properties
        
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage: String?
        @Published var isloading: Bool = false
        @Published var canUseBiometrics = false
        @Published var biometricsImage: Image? = nil
        
        init(
            email: String = "",
            password: String = "",
            errorMessage: String? = nil,
            isloading: Bool = false,
            canUseBiometrics: Bool = false,
            biometricsImage: Image? = nil
        ) {
            self.email = email
            self.password = password
            self.errorMessage = errorMessage
            self.isloading = isloading
            self.canUseBiometrics = canUseBiometrics
            self.biometricsImage = biometricsImage
        }
        
        weak var delegate: LoginViewDelegate?
        
        //MARK: - Methods
        @MainActor
        func login() async {
            isloading = true
            let result = await delegate?.login(email: email, password: password)
            handleLoginResult(result)
            isloading = false
        }
        @MainActor
        func loginWithBiometrics() async {
            isloading = true
            let result = await delegate?.loginWithBiometrics()
            handleLoginResult(result)
            isloading = false
        }
        
        func startCreateUser() {
            delegate?.startCreateUser()
        }
        
        private func handleLoginResult(_ result: AuthenticationResult?) {
            switch result {
            case .success:
                errorMessage = nil
            case .invalidEmail:
                errorMessage = "invalid email"
            case .wrongPassword:
                errorMessage = "wrong password"
            case .other(let error):
                errorMessage = error.localizedDescription
            default:
                errorMessage = "unknown error"
            }
        }
    }
}
