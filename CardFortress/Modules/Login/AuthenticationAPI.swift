//
//  AuthenticationAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/19/23.
//

import Foundation

protocol AuthenticationAPI {
    func signUp(withEmail: String, password: String)
    func signIn(withEmail: String, password: String)
}

enum AuthenticationResult {
    case success
    case failure(Error)
}
