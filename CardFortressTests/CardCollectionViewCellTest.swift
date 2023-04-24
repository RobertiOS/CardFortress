//
//  CardCollectionViewCellTest.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 23/04/23.
//

import XCTest
@testable import CardFortress

final class CardCollectionViewCellTest: XCTestCase {

    func testCardCollectionViewCell_DisplaysText() {
       //given
        let cell: CardCollectionViewCell = .init()
        
        //when
        cell.configure(with: "text 123")
        
        //then
        XCTAssertEqual("text 123", cell.testHooks.textLabel)
    }

}
