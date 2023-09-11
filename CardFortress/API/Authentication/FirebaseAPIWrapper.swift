//
//  FirebaseAPIWrapper.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthAPIWrapper {
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResultProtocol
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultProtocol
    func signOut() throws
    var currentUser: UserProtocol? { get }
}

protocol UserProtocol {
    var uid: String { get }
    var email: String? { get }
}

protocol AuthDataResultProtocol {
    var firebaseUser: UserProtocol { get }
}

final class firebaseAuthAPIWrapper: FirebaseAuthAPIWrapper {
    
    private let auth = Auth.auth()
    
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResultProtocol {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultProtocol {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    var currentUser: UserProtocol? {
        auth.currentUser
    }
}

extension User: UserProtocol { }

extension AuthDataResult: AuthDataResultProtocol {
    var firebaseUser: UserProtocol {
        self.user
    }
}


