//
//  DataStorageAPIMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation

final class DataStorageAPIMock: DataStorageAPI {
    func getUserData(uid: String) async throws -> UserData {
        .init(name: "Juan", lastName: "Perez")
    }
    
    func storeUserData(userUid: String, userData: UserData) async throws {
       
    }
}
