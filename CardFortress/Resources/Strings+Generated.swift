// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum LocalizableString {
  /// Add your card
  internal static let addCreditCardButtonTitle = LocalizableString.tr("Localizable", "addCreditCardButtonTitle", fallback: "Add your card")
  /// New Card
  internal static let addCreditCardTitle = LocalizableString.tr("Localizable", "addCreditCardTitle", fallback: "New Card")
  /// Enter your card information
  internal static let addYourCardInformation = LocalizableString.tr("Localizable", "addYourCardInformation", fallback: "Enter your card information")
  /// Go to other view
  internal static let buttonTest = LocalizableString.tr("Localizable", "buttonTest", fallback: "Go to other view")
  /// Name on card
  internal static let cardHolderNameLabel = LocalizableString.tr("Localizable", "cardHolderNameLabel", fallback: "Name on card")
  /// Juan Perez
  internal static let cardHolderNamePlaceHolder = LocalizableString.tr("Localizable", "cardHolderNamePlaceHolder", fallback: "Juan Perez")
  /// Card Name
  internal static let cardNameLabel = LocalizableString.tr("Localizable", "cardNameLabel", fallback: "Card Name")
  /// e.g: Bank Name
  internal static let cardNamePlaceHolder = LocalizableString.tr("Localizable", "cardNamePlaceHolder", fallback: "e.g: Bank Name")
  /// Card Number
  internal static let cardNumberLabel = LocalizableString.tr("Localizable", "cardNumberLabel", fallback: "Card Number")
  /// 0000 0000 0000 0000
  internal static let cardNumberPlaceHolder = LocalizableString.tr("Localizable", "cardNumberPlaceHolder", fallback: "0000 0000 0000 0000")
  /// This field is required.
  internal static let cfTextFieldGenericErrorMessage = LocalizableString.tr("Localizable", "cfTextFieldGenericErrorMessage", fallback: "This field is required.")
  /// Credit Card Fortress
  internal static let creditCardFortressHeader = LocalizableString.tr("Localizable", "creditCardFortressHeader", fallback: "Credit Card Fortress")
  /// cvv
  internal static let cvvLabel = LocalizableString.tr("Localizable", "cvvLabel", fallback: "cvv")
  /// 123
  internal static let cvvPlaceHolder = LocalizableString.tr("Localizable", "cvvPlaceHolder", fallback: "123")
  /// Save
  internal static let editCreditCardButtonTitle = LocalizableString.tr("Localizable", "editCreditCardButtonTitle", fallback: "Save")
  /// Edit Card
  internal static let editCreditCardTitle = LocalizableString.tr("Localizable", "editCreditCardTitle", fallback: "Edit Card")
  /// Expiry Date
  internal static let expirationDateLabel = LocalizableString.tr("Localizable", "expirationDateLabel", fallback: "Expiry Date")
  /// MM / YY
  internal static let expirationDatePlaceHolder = LocalizableString.tr("Localizable", "expirationDatePlaceHolder", fallback: "MM / YY")
  /// Increase quantity
  internal static let increaseQty = LocalizableString.tr("Localizable", "increaseQty", fallback: "Increase quantity")
  /// Invalid email
  internal static let invalidEmail = LocalizableString.tr("Localizable", "invalidEmail", fallback: "Invalid email")
  /// Card fortress app
  internal static let labelTest = LocalizableString.tr("Localizable", "labelTest", fallback: "Card fortress app")
  /// Log in
  internal static let login = LocalizableString.tr("Localizable", "login", fallback: "Log in")
  /// eng.strings
  ///   CardFortress
  /// 
  ///   Created by Roberto Corrales on 16/04/23.
  internal static let mainViewTitle = LocalizableString.tr("Localizable", "mainViewTitle", fallback: "Card Fortress")
  /// or connect with
  internal static let orConnectWith = LocalizableString.tr("Localizable", "orConnectWith", fallback: "or connect with")
  /// Remember me
  internal static let rememberMe = LocalizableString.tr("Localizable", "rememberMe", fallback: "Remember me")
  /// Scan your card
  internal static let scanYourCard = LocalizableString.tr("Localizable", "scanYourCard", fallback: "Scan your card")
  /// Sign Up
  internal static let signUp = LocalizableString.tr("Localizable", "signUp", fallback: "Sign Up")
  /// The Card Was Added Successfuly
  internal static let snackBarCardAdded = LocalizableString.tr("Localizable", "snackBarCardAdded", fallback: "The Card Was Added Successfuly")
  /// Card saved
  internal static let snackBarCardSaved = LocalizableString.tr("Localizable", "snackBarCardSaved", fallback: "Card saved")
  /// Unknown error
  internal static let unknownError = LocalizableString.tr("Localizable", "unknownError", fallback: "Unknown error")
  /// Wrong password
  internal static let wrongPassword = LocalizableString.tr("Localizable", "wrongPassword", fallback: "Wrong password")
  /// Your email
  internal static let yourEmail = LocalizableString.tr("Localizable", "yourEmail", fallback: "Your email")
  /// Your password
  internal static let yourPassword = LocalizableString.tr("Localizable", "yourPassword", fallback: "Your password")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension LocalizableString {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
