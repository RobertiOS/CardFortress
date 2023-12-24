//
//  UIViewController+ExtensionsTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/23/23.
//

import XCTest
@testable import CardFortress

final class UIViewController_ExtensionsTests: XCTestCase {

    func test_presentSnackBart() {
        // Given
        let viewController = UIViewController()
        
        // When
        viewController.presentSnackbar(with: "Hi")
       
        let snackBar = viewController.view.subviews.first {
            $0 is CFSnackBar
        }
        
        // Then
        XCTAssertNotNil(snackBar)
    }
}
