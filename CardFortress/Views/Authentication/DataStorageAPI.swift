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
    case failure(error: Error)
}

protocol DataStorageAPI {
    /// Store an user into the data base
    /// - Parameters:
    ///   - firstName: First name of the user
    ///   - lastName: Last name of the user
    ///   - userImage: profile image of the user
    ///   - userUUid: The unique id of the user
    /// - Returns: StorageResult
    func storeUserData(
        firstName: String,
        lastName: String,
        userImage: UIImage?,
        userUid: String) async -> StorageResult
}


enum CollectionName: String {
    case userInformation
}


final class DataStorage: DataStorageAPI {
    
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    //MARK: - Methods
    
    func storeUserData(
        firstName: String,
        lastName: String,
        userImage: UIImage?,
        userUid: String) async -> StorageResult {
        let data: [String : Any] = ["name": firstName, lastName: lastName]
            do {
                try await db.collection(.userInformation).document(userUUid).setData(data)
                return .success
            } catch {
                return .failure(error: error)
            }
    }
}

//MARK: - Firestore extension

extension Firestore {
    func collection(_ key: CollectionName) -> CollectionReference {
        collection(key.rawValue)
    }
}
