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
        
        /// delete account if it exists
        secureUserData.deleteAccount()
        
        let getCredentials3 = await secureUserData.getUserCredentials()
        guard case .failure(error: _) = getCredentials3 else { return XCTFail("User credentials not expected at this point") }
        
        let mockloginInfo = LoginInfo(userName: "user", password: "1234")
        let mockloginInfo2 = LoginInfo(userName: "userModified", password: "1234")
        // When
        let result = await secureUserData.storeUserCredentials(userData: mockloginInfo)
        // Then
        guard case .success(let loginInfo) = result else { return XCTFail("User credentials expected at this point") }
        XCTAssertEqual(loginInfo, mockloginInfo)
        
        //when
        let getCredentials = await secureUserData.getUserCredentials()
        guard case .success(let loginInfo2) = getCredentials else { return XCTFail("User credentials expected at this point") }
        
        // then
        XCTAssertEqual(loginInfo2, mockloginInfo)
        
        // When
        let result2 = await secureUserData.storeUserCredentials(userData: mockloginInfo2)
        // Then
        guard case .success(let loginInfo2) = result2 else { return XCTFail("User credentials expected at this point")  }
        
        XCTAssertEqual(loginInfo2, mockloginInfo2)
    }

}
