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
    @Published var errorMessage: String?
    
    @Published var isLoading = false
    
    weak var delegate: CreateUserViewDelegate?
    
    //MARK: - Public methods
    
    @MainActor
    func createUser() async -> CreateUserResult {
        isLoading = true
        guard password == confirmationPassword else {
            errorMessage = ErrorStates.passwordsDoNotMatch.errorMessage
            isLoading = false
            return .error
        }
        let result = await delegate?.createUser(name: name, lastName: lastName, email: email, password: password)
        isLoading = false
        return result == .success ? .success : .error
        
    }
    
    enum ErrorStates {
        case passwordsDoNotMatch
        var errorMessage: String {
            switch self {
            case .passwordsDoNotMatch:
                return LocalizableString.passwordsDoNotMatch
            }
        }
    }
    
    enum CreateUserResult {
        case success
        case error
    }
    
}

