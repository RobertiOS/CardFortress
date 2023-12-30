//
//  String+ExtensionsTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/29/23.
//

import XCTest
import CardFortress

final class String_ExtensionsTests: XCTestCase {

    func test_grouping() {
        // Given
        let testString = "1111222233334444"
        // When
        let resultString = testString.grouping(every: 4, with: " ")
        // Then
        XCTAssertEqual(resultString, "1111 2222 3333 4444")
    }
}
