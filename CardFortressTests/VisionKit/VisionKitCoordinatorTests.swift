//
//  VisionKitCoordinatorTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/4/23.
//

import XCTest
import Swinject
import VisionKit
@testable import CardFortress

final class VisionKitCoordinatorTests: XCTestCase {

    var navigationController: UINavigationController!
    var coordinator: VisionKitCoordinator!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        coordinator = VisionKitCoordinator(factory: MockMainViewControllerFactory(), navigationController: navigationController)
    }

    override func tearDown() {
        super.tearDown()
        navigationController = nil
        coordinator = nil
    }

    func test_Start() {
        //given
        
        //when
        coordinator.start()
        //then
        XCTAssertTrue(navigationController.presentedViewController is VisionKitViewControllerProtocol)
        XCTAssertNil(navigationController.topViewController?.presentingViewController)
    }
    
    func test_VisionKitDelegate() {
        //given
        let mockViewController = VNDocumentCameraViewController()
        //when
        coordinator.documentCameraViewControllerDidCancel(mockViewController)
        //then
        coordinator.onFinish = {
            XCTAssertNotNil($0)
        }
        let error: GenericError = .genericError(description: "")
        //when
        coordinator.documentCameraViewController(mockViewController, didFailWithError: error)
        //then
        coordinator.onFinish = {
            XCTAssertNotNil($0)
        }
    }
    
    
}
