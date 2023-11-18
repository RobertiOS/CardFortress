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
    func getUserCredentials() async -> (email: String, password: String)?
    func startCreateUser()
}

extension LoginView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        //MARK: - Properties
        
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage: String?
        @Published var isloading = false
        @Published var canUseBiometrics = false
        @Published var biometricsImage: Image? = nil
        
        @AppStorage("isRememberMeEnabled") var isRememberMeEnabled: Bool = false {
            didSet {
                if isRememberMeEnabled {
                    getCredentials()
                } else {
                    email = ""
                    password = ""
                }
            }
        }
        
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
            
            getCredentials()
            
        }
        
        weak var delegate: LoginViewDelegate?
        
        //MARK: - Methods

        func login() async {
            isloading = true
            let result = await delegate?.login(email: email, password: password)
            handleLoginResult(result)
            isloading = false
        }

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
                errorMessage = LocalizableString.invalidEmail.value
            case .wrongPassword:
                errorMessage = LocalizableString.wrongPassword.value
            case .other(let error):
                errorMessage = error.localizedDescription
            default:
                errorMessage = LocalizableString.unknownError.value
            }
        }
        
        private func getCredentials() {
            
            Task {
                defer {
                    isloading = false
                }
                
                isloading = true
                guard isRememberMeEnabled,
                let userData = await delegate?.getUserCredentials() else { return }
                
                email = userData.email
                password = userData.password
            }
        }
    }
}
