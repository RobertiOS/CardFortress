//
//  AuthenticationAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/19/23.
//

import Foundation
import FirebaseAuth

protocol AuthenticationAPI {
    /// Creates an account, if the account is created succesfully the new user is logged in
    /// - Parameters:
    ///   - withEmail: The email of the new account
    ///   - password: The password of the account
    /// - Returns: if the account is created successfuly, it returns success
    func signUp(withEmail: String, password: String) async -> AuthenticationResult
    /// Login with an existing account
    /// - Parameters:
    ///   - withEmail: The email of the user
    ///   - password: The password of the account
    /// - Returns: if the user is logged in, it returns success
    func signIn(withEmail: String, password: String) async -> AuthenticationResult
    
    /// Sign out from the current account
    /// - Returns: if the user is signed out successfully it returns sucess
    func signOut() -> AuthenticationResult?
    
    /// The user that is currently logged in
    var currentUser: User? { get }
}

enum AuthenticationResult {
    case success
    case other(Error)
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
}

extension AuthenticationResult: Equatable {
    static func ==(lhs: AuthenticationResult, rhs: AuthenticationResult) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case let (.other(lhsError), .other(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.invalidEmail, .invalidEmail):
                return true
            case (.wrongPassword, .wrongPassword):
                return true
            default:
                return false
            }
        }
}


final class Authentication: AuthenticationAPI {
    //MARK: - properties
    var currentUser: User?
    
    let auth = Auth.auth()
    func signIn(withEmail: String, password: String) async -> AuthenticationResult {
        do {
            let result = try await auth.signIn(withEmail: withEmail, password: password)
            currentUser = result.user
            return .success
        } catch {
            return handleAuthenticationError(error: error)
        }
        
    }
    
    func signUp(withEmail: String, password: String) async -> AuthenticationResult {
        do {
            let result = try await auth.createUser(withEmail: withEmail, password: password)
            currentUser = result.user
            return .success
        } catch {
            return handleAuthenticationError(error: error)
        }
    }
    
    // MARK: - Helper methods
    
    private func handleAuthenticationError(error: Error) -> AuthenticationResult {
        switch AuthErrorCode(_nsError: error as NSError).code {
        case .wrongPassword:
            return .wrongPassword
        case .invalidEmail:
            return .invalidEmail
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        default:
            return .other(error)
        }
    }
    
    func signOut() -> AuthenticationResult? {
        do {
            try auth.signOut()
        } catch {
            return .other(error)
        }
        return nil
    }
}
