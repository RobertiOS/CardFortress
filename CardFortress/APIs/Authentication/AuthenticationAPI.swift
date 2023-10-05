//
//  AuthenticationAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/19/23.
//

import Foundation
import UIKit

protocol AuthenticationAPI {
    /// Creates an account, if the account is created succesfully the new user is logged in
    /// - Parameters:
    ///   - withEmail: The email of the new account
    ///   - password: The password of the account
    ///   - name: The name of the user
    ///   - lastName: Last name of the user
    ///   - image: image of the user
    /// - Returns: if the account is created successfuly, it returns success
    func signUp(withEmail: String,
                password: String,
                name: String,
                lastName: String,
                image: UIImage?) async -> AuthenticationResult
    /// Login with an existing account
    /// - Parameters:
    ///   - withEmail: The email of the user
    ///   - password: The password of the account
    /// - Returns: if the user is logged in, it returns success
    func signIn(withEmail: String, password: String) async -> AuthenticationResult
    
    /// Sign out from the current account
    /// - Returns: if the user is signed out successfully it returns sucess
    func signOut() -> AuthenticationResult
    
    /// The user that is currently logged in
    var currentUser: CurrentUser? { get }
    
    /// Sign-in with biometics of the device e.g: touch id, face ID
    /// - Returns:if the user is logged in, it returns success
    func signInWithBiometrics() async -> AuthenticationResult

    var isUserLoggedIn: Bool { get }
    
    var signInWithBiometrics: Bool { get }
}

extension AuthenticationAPI {
    var signInWithBiometrics: Bool { false }
}

enum AuthenticationResult {
    case success
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    case unkown
    case other(Error)
    
    var errorMessage: String {
        switch self {
        case .success:
            return "Success"
        case .invalidEmail:
            return "Invalid email"
        case .wrongPassword:
            return "Wrong Password"
        case .emailAlreadyInUse:
            return "Email already in use"
        case .unkown:
            return "Unkown Error"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

extension AuthenticationResult: Equatable {
    static func ==(lhs: AuthenticationResult, rhs: AuthenticationResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success),
            (.invalidEmail, .invalidEmail),
            (.wrongPassword, .wrongPassword),
            (.emailAlreadyInUse, .emailAlreadyInUse),
            (.unkown, .unkown):
            return true
        case let (.other(lhsError), .other(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}


final class Authentication: AuthenticationAPI {
    
    //MARK: - properties
    var currentUser: CurrentUser?
    let secureUserDataAPI: SecureUserDataAPI
    let biometricsAPI: BiometricAuthAPI
    let authDataSourceAPI: AuthDataSourceAPI
    
    init(
        secureUserDataAPI: SecureUserDataAPI = SecureUserData(),
        biometricsAPI: BiometricAuthAPI = BiometricAuth(),
        authDataSourceAPI: AuthDataSourceAPI = AuthDataSource()
    ) {
        self.secureUserDataAPI = secureUserDataAPI
        self.biometricsAPI = biometricsAPI
        self.authDataSourceAPI = authDataSourceAPI
    }
   
    func signIn(
        withEmail: String,
        password: String
    ) async -> AuthenticationResult {
        do {
            _ = try await authDataSourceAPI.signIn(email: withEmail, password: password)
            /// store credentials on keychain if the user is logged-in successfully
            if signInWithBiometrics {
                await secureUserDataAPI.storeUserCredentials(userData: .init(userName: withEmail, password: password))
            }
            return .success
        } catch let error as AuthDataSourceError {
            return handleAuthenticationError(error: error)
        } catch {
            return .other(error)
        }
        
    }
    
    func signInWithBiometrics() async -> AuthenticationResult {
        if signInWithBiometrics {
            let result = await biometricsAPI.evaluate()
            switch result {
            case (false, .some(let error)):
                return .other(error)
            case (true, .none):
                let userData = await secureUserDataAPI.getUserCredentials()
                switch userData {
                case .success(let loginInfo):
                    return await signIn(withEmail: loginInfo.userName, password: loginInfo.password)
                case .failure(_):
                    return .other(GenericError.genericError(description: "Other error"))
                }
            default:
                return .other(GenericError.genericError(description: "Biometrics disabled on the API"))
            }
        } else {
            return .other(GenericError.genericError(description: "Biometrics disabled on the API"))
        }
    }
    
    func signUp(withEmail: String,
                password: String,
                name: String,
                lastName: String,
                image: UIImage? = nil
    ) async -> AuthenticationResult {
        do {
            try await authDataSourceAPI.createUser(
                email: withEmail,
                password: password,
                name: name,
                lastName: lastName,
                image: image
            )
            return .success
        } catch let error as AuthDataSourceError {
            return handleAuthenticationError(error: error as AuthDataSourceError)
        } catch {
            return AuthenticationResult.other(error)
        }
    }
    
    func signOut() -> AuthenticationResult {
        do {
            try authDataSourceAPI.signOut()
        } catch {
            return .other(error)
        }
        return .success
    }

    var isUserLoggedIn: Bool {
        authDataSourceAPI.isUserLoggedIn
    }
    
    // MARK: - Helper methods
    
    private func handleAuthenticationError(error: AuthDataSourceError) -> AuthenticationResult {
        switch error {
        case .wrongPassword:
            return .wrongPassword
        case .invalidEmail:
            return .invalidEmail
        case .emailAlreadyInUse:
            return AuthenticationResult.emailAlreadyInUse
        default:
            return .other(error)
        }
    }
}
