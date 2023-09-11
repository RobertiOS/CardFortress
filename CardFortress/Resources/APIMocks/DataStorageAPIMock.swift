//
//  DataStorageAPIMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation

final class DataStorageAPIMock: DataStorageAPI {
    func storeUserData(userUid: String, userData: UserData) async -> StorageResult {
        return .success
    }

    func getUserData(uid: String) async -> Result<UserData?, Error> {
        return .success(.init(name: "Juan", lastName: "Perez"))
    }
    
}
