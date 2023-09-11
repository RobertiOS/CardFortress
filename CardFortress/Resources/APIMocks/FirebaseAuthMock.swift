//
//  FirebaseAuthMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthAPIMock: FirebaseAuthAPIWrapper {
    
    let user = UserMock()
    var logoutCalledCount = 0
    var authErrorCode: AuthErrorCode?

    func createUser(withEmail email: String, password: String) async throws -> AuthDataResultProtocol {
        if let authErrorCode {
            throw authErrorCode
        }
        return AuthDataResultMock()
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultProtocol {
        if let authErrorCode {
            throw authErrorCode
        }
        return AuthDataResultMock()
    }
    
    func signOut() throws {
        logoutCalledCount += 1
        return
    }
    
    var currentUser: UserProtocol? {
        user
    }
    
}

extension FirebaseAuthAPIMock {
    struct UserMock: UserProtocol {
        var email: String? = "robert@gmail.com"
        var uid: String = "1234"
    }

    struct AuthDataResultMock: AuthDataResultProtocol {
        let mockUser =  UserMock()
         
        var firebaseUser: UserProtocol {
            mockUser
        }
    }
}
