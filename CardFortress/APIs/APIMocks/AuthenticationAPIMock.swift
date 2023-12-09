//
//  AuthenticationAPIMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit

final class AuthenticationAPIMock: AuthenticationAPI {
    
    func signInWithBiometrics() async -> AuthenticationResult {
        .success
    }
    
    var currentUser: CurrentUser?
    
    func signUp(withEmail: String, password: String, name: String, lastName: String, image: UIImage?) async -> AuthenticationResult {
        isUserLoggedIn = true
        return .success
    }
    
    func signOut() -> AuthenticationResult {
        .success
    }
    
    func signIn(withEmail: String, password: String) async -> AuthenticationResult {
        return .success
    }

    var isUserLoggedIn: Bool = false
    
}