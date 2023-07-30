//
//  LoginViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/20/23.
//

import Foundation

protocol LoginViewDelegate: AnyObject {
    func login(email: String, password: String) async -> AuthenticationResult?
}

extension LoginView {
    final class ViewModel: ObservableObject {
        
        //MARK: - Properties
        
        weak var delegate: LoginViewDelegate?
        
        //MARK: - Methods
        
        func login(email: String, password: String) async -> AuthenticationResult? {
            return await delegate?.login(email: email, password: password)
        }
    }
}
