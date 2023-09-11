//
//  AuthenticationAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/19/23.
//

import Foundation
import FirebaseAuth
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
    
    //MARK: Configuration
    
    struct Config {
        let useBiometrics: Bool
        
        static var defaults: Self {
            .init(useBiometrics: true)
        }
    }
    
    
    //MARK: - properties
    var currentUser: CurrentUser?
    let dataStorageAPI: DataStorageAPI
    let secureUserDataAPI: SecureUserDataAPI
    let biometricsAPI: BiometricAuthAPI
    let firebaseAuthAPI: FirebaseAuthAPIWrapper
    let config: Config
    
    init(
        dataStorageAPI: DataStorageAPI = DataStorage(),
        secureUserDataAPI: SecureUserDataAPI = SecureUserData(),
        biometricsAPI: BiometricAuthAPI = BiometricAuth(),
        firebaseAuthAPI: FirebaseAuthAPIWrapper = firebaseAuthAPIWrapper(),
        config: Config = Config.defaults
    ) {
        self.dataStorageAPI = dataStorageAPI
        self.secureUserDataAPI = secureUserDataAPI
        self.config = config
        self.biometricsAPI = biometricsAPI
        self.firebaseAuthAPI = firebaseAuthAPI
    }
   
    func signIn(withEmail: String, password: String) async -> AuthenticationResult {
        do {
            _ = try await firebaseAuthAPI.signIn(withEmail: withEmail, password: password)
            /// store credentials on keychain if the user is logged-in successfully
            if config.useBiometrics {
                await secureUserDataAPI.storeUserCredentials(userData: .init(userName: withEmail, password: password))
            }
            try await setCurrentUser()
            return .success
        } catch {
            return handleAuthenticationError(error: error)
        }
        
    }
    
    func signInWithBiometrics() async -> AuthenticationResult {
        if config.useBiometrics {
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
            let result = try await firebaseAuthAPI.createUser(withEmail: withEmail, password: password)
                let userData = UserData(name: name, lastName: lastName)
                let storeUserData = await dataStorageAPI.storeUserData(
                    userUid: result.firebaseUser.uid,
                    userData: userData)
                switch storeUserData {
                case .success:
                    try await setCurrentUser()
                    return .success
                case .failure(let error):
                    return .other(error)
                default:
                    break
                }
            return .success
        } catch {
            return handleAuthenticationError(error: error)
        }
    }
    
    func signOut() -> AuthenticationResult {
        do {
            try firebaseAuthAPI.signOut()
        } catch {
            return .other(error)
        }
        return .success
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
    
    
    //TODO: - Revisit
    func setCurrentUser() async throws {
        guard let uid = firebaseAuthAPI.currentUser?.uid else { throw NSError() }
        let result = await dataStorageAPI.getUserData(uid: uid)
        switch result {
        case.success(let data):
            currentUser = .init(
                name: data?.name ?? "",
                lastName: data?.lastName ?? "",
                email: firebaseAuthAPI.currentUser?.email ?? ""
            )
        case .failure(let error):
            throw error
        }
    }
}
