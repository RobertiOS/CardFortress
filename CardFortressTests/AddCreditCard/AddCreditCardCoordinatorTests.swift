////
////  AddCreditCardCoordinatorTests.swift
////  CardFortressTests
////
////  Created by Roberto Corrales on 6/27/23.
////
//
//import XCTest
//import Swinject
//import VisionKit
//@testable import CardFortress
//
//final class AddCreditCardCoordinatorTests: XCTestCase {
//
//    var navigationController: UINavigationController!
//    
//    override func setUp() {
//        super.setUp()
//        navigationController = UINavigationController()
//        
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
//        let container = Container()
//        let coordinator = AddCreditCardCoordinator(
//            navigationController: navigationController,
//            containter: container,
//            factory: AddCreditCardMockFactory())
//        //when
//        coordinator.start()
//        //then
//        XCTAssertEqual(self.navigationController.viewControllers.count, 1)
//        XCTAssertTrue(self.navigationController.topViewController is AddCreditCardViewControllerProtocol)
//    }
//    
//    func test_startVisionCoordinator() {
//        //given
//        let container = Container()
//        let coordinator = AddCreditCardCoordinator(
//            navigationController: navigationController,
//            containter: container,
//            factory: AddCreditCardMockFactory())
//        //when
//        coordinator.testHooks.startVisionKitCoordinator()
//        //then
//        XCTAssertTrue(self.navigationController.presentedViewController is VNDocumentCameraViewController)
//    }
//
//}
