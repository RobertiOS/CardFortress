//
//  SecureUserDataTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 11/4/23.
//

import XCTest
@testable import CardFortress

final class SecureUserDataTests: XCTestCase {
    
    func test_storeUserCredentials() async {
        // Given
        let secureUserData = SecureUserData(server: .testServer)
        let mockloginInfo = LoginInfo(userName: "user", password: "1234")
        // When
        let result = await secureUserData.storeUserCredentials(userData: mockloginInfo)
        // Then
        guard case .success(let loginInfo) = result else { return }
        XCTAssertEqual(loginInfo, mockloginInfo)
        
        //when
        let getCredentials = await secureUserData.getUserCredentials()
        guard case .success(let loginInfo2) = getCredentials else { return }
        XCTAssertEqual(loginInfo2, mockloginInfo)
    }

}
