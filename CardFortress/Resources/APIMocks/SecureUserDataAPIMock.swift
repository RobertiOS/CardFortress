//
//  SecureUserDataAPIMock.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation

final class SecureUserDataAPIMock: SecureUserDataAPI {
    func storeUserCredentials(userData: LoginInfo) async -> SecureStoreUserDataResult {
        .success(loginInfo: LoginInfo(userName: "User", password: "1234"))
    }
    
    func getUserCredentials() async -> SecureStoreUserDataResult {
        .success(loginInfo: LoginInfo(userName: "User", password: "1234"))
    }
    
}
