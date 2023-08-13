//
//  LoginViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/20/23.
//

import Foundation

protocol LoginViewDelegate: AnyObject {
    func login(email: String, password: String) async -> AuthenticationResult?
    func startCreateUser()
}

extension LoginView {
    
    final class ViewModel: ObservableObject {
        
        //MARK: - Properties
        
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage: String?
        @Published var isloading: Bool = false
        
        weak var delegate: LoginViewDelegate?
        
        //MARK: - Methods
        @MainActor
        func login() async {
            isloading = true
            let result = await delegate?.login(email: email, password: password)
            switch result {
            case .success:
                errorMessage = nil
            case .invalidEmail:
                errorMessage = "invalid email"
            case .wrongPassword:
                errorMessage = "wrong password"
            default:
                errorMessage = "unknown error"
            }
            isloading = false
        }
        
        func startCreateUser() {
            delegate?.startCreateUser()
        }
    }
}
