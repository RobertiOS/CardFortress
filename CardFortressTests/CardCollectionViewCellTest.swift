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
        let card = CreditCard(identifier: UUID(), number: 123, cvv: 123, date: "123", cardName: "Visa", cardHolderName: "Roberto")
        
        //when
        cell.configure(with: card)
        
        //then
        XCTAssertEqual("Visa", cell.testHooks.textLabel)
    }

}
