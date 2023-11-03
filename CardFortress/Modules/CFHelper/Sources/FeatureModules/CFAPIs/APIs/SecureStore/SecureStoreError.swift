//
//  SecureStoreError.swift
//  CardFortress
//
//  Created by Roberto Corrales on 1/05/23.
//

import Foundation

public enum SecureStoreError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
    case jsonDecodingError(message: String)
}

extension SecureStoreError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .string2DataConversionError:
      return NSLocalizedString("String to Data conversion error", comment: "")
    case .data2StringConversionError:
      return NSLocalizedString("Data to String conversion error", comment: "")
    case .unhandledError(let message):
      return NSLocalizedString(message, comment: "")
    case .jsonDecodingError(let message):
      return NSLocalizedString(message, comment: "")
    }
  }
}
