//
//  AuthtenticaitonAPITests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 9/10/23.
//
import XCTest
import FirebaseAuth
@testable import CardFortress

final class AuthtenticaitonAPITests: XCTestCase {

    var authenticationAPI: AuthenticationAPI!
    var firebaseAPIMock: FirebaseAuthAPIMock!
    
    override func setUp() {
        super.setUp()
        firebaseAPIMock = FirebaseAuthAPIMock()
        authenticationAPI = Authentication(
            dataStorageAPI: DataStorageAPIMock(),
            secureUserDataAPI: SecureUserDataAPIMock(),
            biometricsAPI: BiometricAuthAPIMock(),
            firebaseAuthAPI: firebaseAPIMock,
            config: .defaults
        )
    }
    
    override func tearDown() {
        super.tearDown()
        authenticationAPI = nil
        firebaseAPIMock = nil
    }
    
    func test_signIn() async throws {
        //given
        
        //when
        let result = await authenticationAPI.signIn(withEmail: "1234", password: "1234")
        //then
        XCTAssertEqual(result, .success)
    }
    
    func test_signIn_WrongPassword() async throws {
        //given
        firebaseAPIMock.authErrorCode = AuthErrorCode(.wrongPassword)
        //when
        let result = await authenticationAPI.signIn(withEmail: "1234", password: "1234")
        //then
        XCTAssertEqual(result, .wrongPassword)
    }
    
    func test_signInWithBiometrics() async throws {
        //given
        
        //when
        let result = await authenticationAPI.signInWithBiometrics()
        //then
        XCTAssertEqual(result, .success)
    }
    
    func test_logout() {
        //given
        
        //when
        let result = authenticationAPI.signOut()
        //then
        XCTAssertEqual(result, .success)
        XCTAssertEqual(firebaseAPIMock.logoutCalledCount, 1)
    }
    
    func test_signUp() async {
        //given
        
        //when
        let result = await authenticationAPI.signUp(withEmail: "", password: "", name: "", lastName: "", image: nil)
        //then
        XCTAssertEqual(result, .success)
    }
    
    func test_ErrorMessage() {
        let successResult: AuthenticationResult = .success
        XCTAssertEqual(successResult.errorMessage, "Success")
        
        let invalidEmailResult: AuthenticationResult = .invalidEmail
        XCTAssertEqual(invalidEmailResult.errorMessage, "Invalid email")
        
        let wrongPasswordResult: AuthenticationResult = .wrongPassword
        XCTAssertEqual(wrongPasswordResult.errorMessage, "Wrong Password")
        
        let emailAlreadyInUseResult: AuthenticationResult = .emailAlreadyInUse
        XCTAssertEqual(emailAlreadyInUseResult.errorMessage, "Email already in use")
        
        let unknownResult: AuthenticationResult = .unkown
        XCTAssertEqual(unknownResult.errorMessage, "Unkown Error")
        
        let customError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Custom error"])
        let otherErrorResult: AuthenticationResult = .other(customError)
        XCTAssertEqual(otherErrorResult.errorMessage, "Custom error")
    }
}
