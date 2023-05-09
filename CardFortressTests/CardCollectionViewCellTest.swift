//
//  CardCollectionViewCellTest.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 23/04/23.
//

import XCTest
import CreditCardValidator
@testable import CardFortress

final class CardCollectionViewCellTest: XCTestCase {

    func testCardCollectionViewCell_DisplaysText() {
       //given
        let cell: CardCollectionViewCell = .init()
        let visaIcon = CreditCardType.visa.icon?.aspectFittedToHeight(65)
        let card = CreditCard(
            number: 4098480010653433,
            cvv: 123,
            date: "12/12",
            cardName: "Banpro",
            cardHolderName: "Roberto")
        
        //when
        cell.configure(with: card)
        
        //then
        XCTAssertEqual("12/12", cell.testHooks.dateLabelText)
        XCTAssertEqual("4098 4800 1065 3433", cell.testHooks.cardNumberLabelText)
        XCTAssertEqual("Banpro", cell.testHooks.cardNameText)
        XCTAssertEqual("ROBERTO", cell.testHooks.cardHolderNameText)
        XCTAssertEqual("123", cell.testHooks.cvvLabelText)
        XCTAssertEqual(visaIcon?.pngData(), cell.testHooks.cardTypeImage?.pngData())
        XCTAssertEqual(UIImage(named: "chip")?.pngData(), cell.testHooks.chipImage?.pngData())
    }
    
    func testCardCollectionViewCell_Button_CopyCardNumber() {
       //given
        let cell: CardCollectionViewCell = .init()
        let card = CreditCard(
            number: 4098480010653433,
            cvv: 123,
            date: "12/12",
            cardName: "Banpro",
            cardHolderName: "Roberto")
        
       
        
        //when
        cell.configure(with: card)
        cell.testHooks.copyCardNumberButton.sendActions(for: .touchUpInside)
        
        let copiedText = UIPasteboard.general.string
        
        //then
        XCTAssertEqual("4098 4800 1065 3433", copiedText)
    }

}
