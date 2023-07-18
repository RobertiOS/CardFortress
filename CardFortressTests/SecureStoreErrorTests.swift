import XCTest
@testable import CardFortress

class SecureStoreErrorTests: XCTestCase {
    
    func testErrorDescription() {
        XCTAssertEqual(SecureStoreError.string2DataConversionError.errorDescription, "String to Data conversion error")
        XCTAssertEqual(SecureStoreError.data2StringConversionError.errorDescription, "Data to String conversion error")
        
        let unhandledError = SecureStoreError.unhandledError(message: "Unhandled error")
        XCTAssertEqual(unhandledError.errorDescription, "Unhandled error")
        
        let jsonDecodingError = SecureStoreError.jsonDecodingError(message: "JSON decoding error")
        XCTAssertEqual(jsonDecodingError.errorDescription, "JSON decoding error")
    }
    
}
