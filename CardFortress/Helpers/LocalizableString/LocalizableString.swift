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
    
    //MARK: Add credit card view controller
    case cardNumberLabel
    case expirationDateLabel
    case cardHolderNameLabel
    case cardNameLabel
    case addCreditCardButtonTitle
    case addCreditCardTitle
    case cardNumberPlaceHolder
    case expirationDatePlaceHolder
    case cardHolderNamePlaceHolder
    case cardNamePlaceHolder
    case addYourCardInformation
    case scanYourCard
    case cvvPlaceHolder
    case cvvLabel
    
    //MARK: - CFTextField
    case cfTextFieldGenericErrorMessage
    
    //MARK: - snackbar
    case snackBarCardAdded
    
    //MARK: - Login view
    case invalidEmail
    case wrongPassword
    case unknownError
    case creditCardFortressHeader
    case login
    case yourEmail
    case yourPassword
    case rememberMe
    case signUp
    case orConnectWith
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
