//
//  CoordinatorFactoryTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/13/23.
//

import XCTest
import Swinject
@testable import CardFortress

final class CoordinatorFactoryTests: XCTestCase {

    var factory: CoordinatorFactory!
    let container: Container = {
        let container = Container()
        container.register(AuthenticationAPI.self) { r in
            AuthenticationAPIMock()
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        factory = .init(container: container, viewControllerFactory: MockMainViewControllerFactory())
    }
    
    override func tearDown() {
        super.tearDown()
        factory = nil
    }
    
    func test_makeCoordinators() {
        //when
        let listCoordinator = factory.makeMainListCoordinator()
        let loginCoordinator = factory.makeAuthCoordinator(navigationController: UINavigationController())
        let addCreditCardCoordinator = factory.makeAddCreditCardCoordinator()
        let tabbarCoordinator = factory.makeTabBarCoordinator(navigationController: UINavigationController())
        let visionKitCoordinator = factory.makeVisionKitCoordinator(navigationController: UINavigationController())
        //then
        XCTAssertTrue(listCoordinator is CardListCoordinator)
        XCTAssertTrue(loginCoordinator is AuthCoordinator)
        XCTAssertTrue(addCreditCardCoordinator is AddCreditCardCoordinator)
        XCTAssertNotNil(tabbarCoordinator)
        XCTAssertTrue(visionKitCoordinator is VisionKitCoordinator)
        
    }

}
