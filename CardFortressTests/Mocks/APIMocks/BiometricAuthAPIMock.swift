//
//  BiometricAuthAPIMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation

final class BiometricAuthAPIMock: BiometricAuthAPI {
    func canEvaluate() -> CardFortress.CanEvaluateResult {
        .init(canEvaluate: true, biometricType: .faceID, error: nil)
    }
    
    func evaluate() async -> (Bool, CardFortress.BiometricError?) {
        (true, nil)
    }
}
