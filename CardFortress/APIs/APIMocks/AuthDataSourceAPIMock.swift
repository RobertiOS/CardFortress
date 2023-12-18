//
//  AuthDataSourceAPIMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import UIKit

final class AuthDataSourceAPIMock: AuthDataSourceAPI {

    var currentUser: AuthDataSourceUser?
    var isUserLoggedIn: Bool = false
    var logoutCalledCount = 0
    var authErrorCode: AuthDataSourceError?

    func signUp(email: String, password: String, name: String, lastName: String, image: UIImage?) async throws {
        if let authErrorCode {
            throw authErrorCode
        }
    }
    
    func signIn(email: String, password: String) async throws {
        if let authErrorCode {
            throw authErrorCode
        }
    }
    
    func signOut() throws {
        logoutCalledCount += 1
        return
    }
}
