//
//  ImageParserTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 7/17/23.
//

import XCTest
@testable import CardFortress

final class ImageParserTests: XCTestCase {
    
    var imageParser: ImageParserProtocol!

    override func setUp() {
        super.setUp()
        
        imageParser = ImageParser()
    }

    override func tearDownWithError() throws {
        imageParser = nil
    }
    
    func test_ImageParser() async {
        //given
        let image = UIImage(named: "creditCardMock")
        //when
       
        let expectation = self.expectation(description: "Wait for image parser")
        
        Task {
            let creditCard = await imageParser.mapUIImageToCreditCard(image: image)
            //then
            XCTAssertEqual(creditCard?.cardName, "ROBERTO CORRALES")
            XCTAssertEqual(creditCard?.number, 4349121529668838)
            XCTAssertEqual(creditCard?.date, "01/2025")
            expectation.fulfill()
        }
        
        await waitForExpectations(timeout: .largeWait)
    }
    
    func test_ImageParser_nilImage() async {
        //given
        let image: UIImage? = nil
        //when
        let expectation = self.expectation(description: "Wait for image parser")
        
        Task {
            let creditCard = await imageParser.mapUIImageToCreditCard(image: image)
            //then
            XCTAssertNil(creditCard?.cardName)
            XCTAssertNil(creditCard?.number)
            XCTAssertNil(creditCard?.date)
            expectation.fulfill()
        }
        
        await waitForExpectations(timeout: .largeWait)

    }
}
