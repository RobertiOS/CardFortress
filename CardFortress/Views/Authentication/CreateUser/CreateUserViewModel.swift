//
//  CreateUserViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 8/12/23.
//

import Foundation

protocol CreateUserViewDelegate: AnyObject {
    func createUser(
        name: String,
        lastName: String,
        email: String,
        password: String
    ) async -> AuthenticationResult
}

enum CreateUserValidation {
    case passwordsDonotMatch
}

final class CreateUserViewModel: ObservableObject {
    //MARK: - Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmationPassword = ""
    @Published var errorMessage = ""
    
    weak var delegate: CreateUserViewDelegate?
    
    //MARK: - Public methods
    func createUser() async {
        
        guard password == confirmationPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        let result = await delegate?.createUser(name: name, lastName: lastName, email: email, password: password)
        
        
    }
    
}

