//
//  UIView+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 1/05/23.
//

import Foundation
import UIKit

@resultBuilder
struct SubviewBuilder {

    static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }

    static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }

}


extension UIView {
    func addAutoLayoutSubviews(@SubviewBuilder views: () -> [UIView]) {
        views().forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
    }
}
