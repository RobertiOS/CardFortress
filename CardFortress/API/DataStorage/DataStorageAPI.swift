//
//  DataStorageAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 8/13/23.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

enum StorageResult {
    case success
    case encodingError
    case failure(error: Error)
    case userData(UserData)
}

protocol DataStorageAPI {
    /// Store an user into the data base
    /// - Parameters:
    ///   - userUid: unique identifier
    ///   - userData: user data object to store into the database
    /// - Returns: Storage result
    func storeUserData(userUid: String, userData: UserData) async -> StorageResult
    /// Get user data given an user id
    /// - Parameter uid: the unique id of the user
    /// - Returns: either the user data or an error
    func getUserData(uid: String) async -> Result<UserData?, Error>
}


enum CollectionName: String {
    case userInformation
}

final class DataStorage: DataStorageAPI {
    
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    //MARK: - Methods
    
    func storeUserData(userUid: String, userData: UserData) async -> StorageResult {
        do {
            let jsonData = try JSONEncoder().encode(userData)
            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return .encodingError
            }
            try await db.collection(.userInformation).document(userUid).setData(dictionary)
            return .success
        } catch {
            return .failure(error: error)
        }
    }
    
    func getUserData(uid: String) async -> Result<UserData?, Error> {
        let docRef = db.collection(.userInformation).document(uid)
        do {
            let data = try await docRef.getDocument(source: .default).data()
            let jsonData = try JSONSerialization.data(withJSONObject: data ?? [:], options: [])
            let information = try JSONDecoder().decode(UserData.self, from: jsonData)
            return .success(information)
        } catch {
            return.failure(error)
        }
    }
}

//MARK: - Firestore extension

extension Firestore {
    func collection(_ key: CollectionName) -> CollectionReference {
        collection(key.rawValue)
    }
}
