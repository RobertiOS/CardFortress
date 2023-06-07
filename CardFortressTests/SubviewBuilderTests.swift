//
//  SubviewBuilderTests.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 5/11/23.
//

@testable import CardFortress
import Foundation
import XCTest
import UIKit

class SubviewBuilderTests: XCTestCase {

    func testAddOneSubview() {
        //given
        let view = UIView()
        
        //when
        view.addAutoLayoutSubviews {
            UIView()
        }
        
        //then
        XCTAssertEqual(view.subviews.count, 1)
    }
    
    func testAddMultipleSubviews() {
        //given
        let view = UIView()
        let view2 = UIView()
        
        //when
        view.addAutoLayoutSubviews {
            UIView()
            UIButton()
        }
        
        view2.addAutoLayoutSubviews {
            [ UIButton(),
              UIView(),
              UITextField()
            ]
        }
        
        //then
        XCTAssertEqual(view.subviews.count, 2)
        XCTAssertEqual(view2.subviews.count, 3)
        
    }
}
