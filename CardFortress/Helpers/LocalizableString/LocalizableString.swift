//
//  LocalizableString.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation

enum LocalizableString {
    case mainViewTitle
    case buttonTest
    case labelTest
    case increaseQty
}

extension LocalizableString {
    private var key: String {
        let key = String(describing: self)
        if let index = key.firstIndex(of: "(") {
            return String(key[..<index])
        } else {
            return key
        }
    }

    /// The localized value for this instance. (Wrapper around `String(format:_:)` and `NSLocalizedString()`.)
    var value: String {
        let value = NSLocalizedString(key, bundle: .main, comment: "")
        precondition(value != key, "No localized string found for '\(key)'")
        return value
    }
}
