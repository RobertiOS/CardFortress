//
//  CoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 21/04/23.
//

import XCTest
@testable import CardFortress

final class CoordinatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChildCoordinatorStaysAlive() {
        weak var weakChildCoordinator: MockCoordinator1?

        let parentCoordinator = MockCoordinator2()

        let expectation = self.expectation(description: "expectation")
        expectation.isInverted = true

        autoreleasepool {
            let childCoordinator = MockCoordinator1()
            parentCoordinator.addChild(coordinator: childCoordinator)
            weakChildCoordinator = childCoordinator

            childCoordinator.start()

            XCTAssertNotNil(weakChildCoordinator)
        }

        wait(for: [expectation], timeout: .defaultWait)
        XCTAssertNotNil(weakChildCoordinator)
    }

    func testChildCoordinatorDeallocated() {
        weak var weakChildCoordinator: MockCoordinator2?

        let parentCoordinator = MockCoordinator1()

        let expectation = self.expectation(description: "expectation")
        autoreleasepool {
            let childCoordinator = MockCoordinator2()
            parentCoordinator.addChild(coordinator: childCoordinator)
            weakChildCoordinator = childCoordinator

            childCoordinator.onFinish = { val in
                XCTAssertEqual(val, 0)
                expectation.fulfill()
            }

            childCoordinator.start()

            XCTAssertNotNil(weakChildCoordinator)
        }

        wait(for: [expectation], timeout: .defaultWait)
        XCTAssertNil(weakChildCoordinator)
    }

}

private class MockCoordinator1: Coordinator<Never> {
    override func start() {
        super.start()
    }
}

private class MockCoordinator2: Coordinator<Int> {
    override func start() {
        super.start()

        finish(0)
    }
}
