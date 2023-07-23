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
}

enum AuthenticationResult {
    case success
    case other(Error)
    case invalidEmail
    case wrongPassword
}


final class Authentication: AuthenticationAPI {
    func signIn(withEmail: String, password: String) async -> AuthenticationResult {
        await withCheckedContinuation({ continuation in
            Auth.auth().signIn(withEmail: withEmail, password: password) { (authResult, error) in
                if let error = error as? NSError {
                    switch AuthErrorCode(_nsError: error).code {
                    case .wrongPassword:
                        return continuation.resume(returning: .wrongPassword)
                    case .invalidEmail:
                        continuation.resume(returning: .invalidEmail)
                    default:
                        continuation.resume(returning: .other(error))
                    }
                } else {
                    continuation.resume(returning: .success)
                    let userInfo = Auth.auth().currentUser
                    let email = userInfo?.email
                }
            }
        })
    }
    
    func signUp(withEmail: String, password: String) async -> AuthenticationResult {
        .success
    }
}
