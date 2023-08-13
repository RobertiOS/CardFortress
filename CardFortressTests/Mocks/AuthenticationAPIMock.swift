//
//  AuthenticationAPIMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit
import FirebaseAuth

@testable import CardFortress

final class AuthenticationAPIMock: AuthenticationAPI {
    func signUp(withEmail: String, password: String, name: String, lastName: String, image: UIImage?) async -> CardFortress.AuthenticationResult {
        .success
    }
    
    func signOut() -> CardFortress.AuthenticationResult? {
        nil
    }
    
    func signUp(withEmail: String, password: String) async -> CardFortress.AuthenticationResult {
        return .success
    }
    
    func signIn(withEmail: String, password: String) async -> CardFortress.AuthenticationResult {
        return .success
    }
    
    var currentUser: User?
    
}
