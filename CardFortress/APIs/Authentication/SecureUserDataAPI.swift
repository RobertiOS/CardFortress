//
//  SecureUserDataAPI.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/4/23.
//

import Foundation

struct LoginInfo {
    let userName: String
    let password: String
}

extension LoginInfo {
    init?(item: CFTypeRef?) {
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            return nil
        }
        self.init(userName: account, password: password)
    }
}

//TODO: Remove optional error
enum SecureStoreUserDataResult {
    case success(loginInfo: LoginInfo)
    case failure(error: Error?)
}

protocol SecureUserDataAPI {
    @discardableResult
    func storeUserCredentials(userData: LoginInfo) async -> SecureStoreUserDataResult
    @discardableResult
    func getUserCredentials() async -> SecureStoreUserDataResult
}

class SecureUserData: SecureUserDataAPI {
    
    struct Constants {
        static let server = "com.cardFortress.login"
    }
    
    //TODO: - map errors
    func storeUserCredentials(userData: LoginInfo) async -> SecureStoreUserDataResult {
        
        guard let pwData = userData.password.data(using: .utf8) else {
            return.failure(error: nil)
        }
        
        return await withCheckedContinuation { continuation in
            let account = userData.userName
            let searchAccountQuery: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: Constants.server,
            ]
            
            let searchStatus = SecItemCopyMatching(searchAccountQuery as CFDictionary, nil)
            
            switch searchStatus {
            case errSecSuccess:
                let attributesToUpdate: [String: Any] = [
                    kSecAttrAccount as String: account,
                    kSecValueData as String: pwData
                ]
                
                let status = SecItemUpdate(
                    searchAccountQuery as CFDictionary,
                    attributesToUpdate as CFDictionary
                )
                
                return status == errSecSuccess ?
                continuation.resume(returning: .success(loginInfo: userData)) :
                continuation.resume(returning: .failure(error: nil))
                
            case errSecItemNotFound:
                let query: [String: Any] = [
                    kSecClass as String: kSecClassInternetPassword,
                    kSecAttrServer as String: Constants.server,
                    kSecAttrAccount as String: account,
                    kSecValueData as String: pwData
                ]
                let status = SecItemAdd(query as CFDictionary, nil)
                return status == errSecSuccess ?
                continuation.resume(returning: .success(loginInfo: userData)) :
                continuation.resume(returning: .failure(error: nil))
            default:
                continuation.resume(returning: .failure(error: nil))
            }
        }
    }
    
    //TODO: - map errors
    
    func getUserCredentials() async -> SecureStoreUserDataResult {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: Constants.server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        return await withCheckedContinuation { continuation in
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            guard status != errSecItemNotFound else {
                continuation.resume(returning: .failure(error: nil))
                return
            }
            guard status == errSecSuccess else {
                continuation.resume(returning: .failure(error: nil))
                return
            }
            
            guard let loginInfo = LoginInfo(item: item) else {
                continuation.resume(returning: .failure(error: nil))
                return
            }
            
            continuation.resume(returning: .success(loginInfo: loginInfo))
        }
    }
    
    private func addToKeychain(query: [String : Any]) -> Bool {
        let result = SecItemAdd(query as CFDictionary, nil)
        return result == errSecSuccess
    }
}
