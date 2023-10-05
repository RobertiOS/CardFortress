//
//  BiometricAuth.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/3/23.
//
import UIKit.UIImage
import SwiftUI
import LocalAuthentication

protocol BiometricAuthAPI {
    func canEvaluate() -> CanEvaluateResult
    func evaluate() async -> (Bool, BiometricError?)
}

final class BiometricAuth: BiometricAuthAPI {
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
         localizedReason: String = "Verify your Identity",
         localizedFallbackTitle: String = "Enter App Password",
         localizedCancelTitle: String = "Touch me not") {
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedFallbackTitle = localizedFallbackTitle
        context.localizedCancelTitle = localizedCancelTitle
    }
    
    func canEvaluate() -> CanEvaluateResult {
        var error: NSError?
        // Asks Context if it can evaluate a Policy
        // Passes an Error pointer to get error code in case of failure
        guard context.canEvaluatePolicy(policy, error: &error) else {
            let type = BiometricType(type: context.biometryType)
            guard let error = error else {
                return CanEvaluateResult(canEvaluate: false, biometricType: type, error: nil)
            }
            
            return CanEvaluateResult(canEvaluate: false, biometricType: type, error: BiometricError(nsError: error))
        }
        
        return CanEvaluateResult(canEvaluate: true, biometricType: BiometricType(type: context.biometryType), error: nil)
    }
    
    func evaluate() async -> (Bool, BiometricError?) {
        
        let canEvaluateResult = canEvaluate()
        guard canEvaluateResult.canEvaluate else { return (canEvaluateResult.canEvaluate, canEvaluateResult.error) }
        
        return await withCheckedContinuation { continuation in
            // Asks Context to evaluate a Policy with a LocalizedReason
            context.evaluatePolicy(policy, localizedReason: localizedReason) { success, error in
                // Moves to the main thread because completion triggers UI changes
                if success {
                    // Context successfully evaluated the Policy
                    continuation.resume(returning: (true, nil))
                } else {
                    // Unwraps Error
                    // If not available, sends false for Success & nil for BiometricError
                    guard let error = error else { return continuation.resume(returning: (false, nil)) }
                    // Maps error to our BiometricError
                    continuation.resume(returning: (false, BiometricError(nsError: error as NSError)))
                }
            }
        }
    }
    
}

struct CanEvaluateResult {
    let canEvaluate: Bool
    let biometricType: BiometricType
    let error: BiometricError?
}

enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

extension BiometricType {
    init(type: LABiometryType) {
        switch type {
        case .none:
            self = .none
        case .touchID:
            self = .touchID
        case .faceID:
            self = .faceID
        @unknown default:
            self = .unknown
        }
    }
    
    var iconUIImage: UIImage? {
        switch self {
        case .touchID:
            return UIImage(systemName: "touchid")
        case .faceID:
            return UIImage(systemName: "faceid")
        case .unknown, .none:
            return nil
        }
    }
    
    var iconImage: Image? {
        switch self {
        case .touchID:
            return Image(systemName: "touchid")
        case .faceID:
            return Image(systemName: "faceid")
        case .unknown, .none:
            return nil
        }
    }
    
}

enum BiometricError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown

    var errorDescription: String? {
        switch self {
        case .authenticationFailed: return "There was a problem verifying your identity."
        case .userCancel: return "You pressed cancel."
        case .userFallback: return "You pressed password."
        case .biometryNotAvailable: return "Face ID/Touch ID is not available."
        case .biometryNotEnrolled: return "Face ID/Touch ID is not set up."
        case .biometryLockout: return "Face ID/Touch ID is locked."
        case .unknown: return "Face ID/Touch ID may not be configured"
        }
    }
}

extension BiometricError {
    init(nsError: NSError) {
        switch nsError {
        case LAError.authenticationFailed:
            self = .authenticationFailed
        case LAError.userCancel:
            self = .userCancel
        case LAError.userFallback:
            self = .userFallback
        case LAError.biometryNotAvailable:
            self = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            self = .biometryNotEnrolled
        case LAError.biometryLockout:
            self = .biometryLockout
        default:
            self = .unknown
        }
    }
}

