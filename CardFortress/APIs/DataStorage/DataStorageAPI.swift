//
//  DataStorageAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 8/13/23.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

enum DataStorageAPIError: Error {
    case encodingError
    case decodingError
    case unknown(error: Error)
}

protocol DataStorageAPI {
    /// Store an user into the data base
    /// - Parameters:
    ///   - userUid: unique identifier
    ///   - userData: user data object to store into the database
    /// - Returns: Storage result
    func storeUserData(userUid: String, userData: UserData) async throws
    /// Get user data given an user id
    /// - Parameter uid: the unique id of the user
    /// - Returns: either the user data or an error
    func getUserData(uid: String) async throws -> UserData
}


enum CollectionName: String {
    case userInformation
}

final class DataStorage: DataStorageAPI {
    
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    //MARK: - Methods
    
    func storeUserData(userUid: String, userData: UserData) async throws {
        do {
            let jsonData = try JSONEncoder().encode(userData)
            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw DataStorageAPIError.encodingError
            }
            try await db.collection(.userInformation).document(userUid).setData(dictionary)
        } catch _ as EncodingError {
            throw DataStorageAPIError.encodingError
        } catch _ as DecodingError {
            throw DataStorageAPIError.decodingError
        } catch {
            throw DataStorageAPIError.unknown(error: error)
        }
    }
    
    func getUserData(uid: String) async throws -> UserData {
        let docRef = db.collection(.userInformation).document(uid)
        do {
            let data = try await docRef.getDocument(source: .default).data()
            let jsonData = try JSONSerialization.data(withJSONObject: data ?? [:], options: [])
            let userData = try JSONDecoder().decode(UserData.self, from: jsonData)
            return userData
        } catch _ as EncodingError {
            throw DataStorageAPIError.encodingError
        } catch _ as DecodingError {
            throw DataStorageAPIError.decodingError
        } catch {
            throw DataStorageAPIError.unknown(error: error)
        }
    }
}

//MARK: - Firestore extension

extension Firestore {
    func collection(_ key: CollectionName) -> CollectionReference {
        collection(key.rawValue)
    }
}
