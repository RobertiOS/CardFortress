////
////  VisionKitCoordinatorTests.swift
////  CardFortressTests
////
////  Created by Roberto Corrales on 7/4/23.
////
//
//import XCTest
//import Swinject
//import VisionKit
//@testable import CardFortress
//
//final class VisionKitCoordinatorTests: XCTestCase {
//
//    var navigationController: UINavigationController!
//    
//    override func setUp() {
//        super.setUp()
//        navigationController = UINavigationController()
//        navigationController.loadViewIfNeeded()
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        navigationController = nil
//    }
//
//    func test_Start() {
//        //given
//        let coordinator = VisionKitCoordinator(factory: AddCreditCardMockFactory(), navigationController: navigationController)
//        //when
//        coordinator.start()
//        //then
//        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 1)
//        XCTAssertTrue(coordinator.navigationController.presentedViewController is VNDocumentCameraViewController)
//    }
//}
