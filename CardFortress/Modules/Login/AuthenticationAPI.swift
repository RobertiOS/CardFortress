//
//  AuthenticationAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/19/23.
//

import Foundation
import FirebaseAuth

protocol AuthenticationAPI {
    func signUp(withEmail: String, password: String) async -> AuthenticationResult
    func signIn(withEmail: String, password: String) async -> AuthenticationResult
    var currentUser: User? { get }
}

enum AuthenticationResult {
    case success
    case other(Error)
    case invalidEmail
    case wrongPassword
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
            switch AuthErrorCode(_nsError: error as NSError).code {
            case .wrongPassword:
                return .wrongPassword
            case .invalidEmail:
                return .invalidEmail
            default:
                return .other(error)
            }
        }
        
    }
    
    func signUp(withEmail: String, password: String) async -> AuthenticationResult {
        .success
    }
}
