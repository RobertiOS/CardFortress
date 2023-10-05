//
//  AuthDataSourceAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import UIKit.UIImage
import FirebaseAuth

protocol AuthDataSourceAPI {
    func createUser(
        email: String,
        password: String,
        name: String,
        lastName: String,
        image: UIImage?
    ) async throws
    func signIn(
        email: String,
        password: String
    ) async throws
    func signOut() throws
    var currentUser: AuthDataSourceUser? { get }
    var isUserLoggedIn: Bool { get }
}

protocol UserProtocol {
    var uid: String { get }
    var email: String? { get }
}

struct AuthDataSourceUser {
    let id: String
    let email: String?
    let name: String
    let lastName: String
    let image: UIImage?
}

protocol AuthDataResultProtocol {
    var firebaseUser: UserProtocol { get }
}

final class AuthDataSource: AuthDataSourceAPI {
    func createUser(email: String, password: String, name: String, lastName: String, image: UIImage?) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let userData = UserData(name: name, lastName: lastName)
            try await dataStorageAPI.storeUserData(
                    userUid: result.firebaseUser.uid,
                    userData: userData)
        } catch let error as DataStorageAPIError {
            throw AuthDataSourceError.dataSourceError(error)
        } catch {
            throw AuthDataSourceError(error: error)
        }
    }
    
    
    //MARK: - Private properties
    private let dataStorageAPI: DataStorageAPI
    private let auth = Auth.auth()
    
    //MARK: - Public properties
    var currentUser: AuthDataSourceUser?
    init(dataStorageAPI: DataStorageAPI = DataStorage()) {
        self.dataStorageAPI = DataStorage()
    }

    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(withEmail: email, password: password)
            try await setCurrentUser()
        } catch let error as DataStorageAPIError {
            throw AuthDataSourceError.dataSourceError(error)
        } catch {
            throw AuthDataSourceError(error: error)
        }
    }

    func signOut() throws {
        do {
            return try auth.signOut()
        } catch {
            throw AuthDataSourceError(error: error)
        }
    }
    
    private func setCurrentUser() async throws {
        guard let uid = auth.currentUser?.uid else { return }
        let result = try await dataStorageAPI.getUserData(uid: uid)
        self.currentUser = .init(id: uid, email: auth.currentUser?.email, name: result.name, lastName: result.lastName, image: nil)
    }
    
    var isUserLoggedIn: Bool {
        auth.currentUser != nil
    }
}

enum AuthDataSourceError: Error {
    case dataSourceError(Error)
    case wrongPassword
    case invalidEmail
    case emailAlreadyInUse
    case unknowned(Error)
    
    init(error: Error) {
        switch AuthErrorCode(_nsError: error as NSError).code {
        case .wrongPassword:
            self = .wrongPassword
        case .invalidEmail:
            self = .invalidEmail
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse
        default:
            self = .unknowned(error)
        }
    }
}

extension User: UserProtocol { }

extension AuthDataResult: AuthDataResultProtocol {
    var firebaseUser: UserProtocol {
        self.user
    }
}


