//
//  CreateUserViewModelTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 11/30/23.
//

import XCTest
@testable import CardFortress

final class CreateUserViewModelTests: XCTestCase {

    func test_createUser_passwordsDoNotMatch() async {
        // Given
        let viewModel = CreateUserViewModel()
        // When
        viewModel.password = "1234"
        viewModel.confirmationPassword = "123"
        let result = await viewModel.createUser()
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Passwords do not match")
        XCTAssertEqual(result, .error)
        
    }
    
    func test_createUser_passwordsMatch() async {
        // Given
        let viewModel = CreateUserViewModel()
        let delegate = CreateUserViewDelegateMock()
        viewModel.delegate = delegate
        // When
        viewModel.password = "1234"
        viewModel.confirmationPassword = "1234"
        let result = await viewModel.createUser()
        // Then
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(result, .success)
        
    }
}

fileprivate class CreateUserViewDelegateMock: CreateUserViewDelegate {
    func createUser(name: String, lastName: String, email: String, password: String) async -> CardFortress.AuthenticationResult {
        .success
    }
}
