//
//  LoginViewModel+Presentation.swift
//  CardFortress
//
//  Created by Roberto Corrales on 9/10/23.
//

import Foundation

extension LoginView.ViewModel {
    convenience init(biometricAuthAPI: BiometricAuthAPI = BiometricAuth()){
        let canEvaluateResult = biometricAuthAPI.canEvaluate()
        let biometricsImage = canEvaluateResult.biometricType.iconImage
        
        self.init(
            canUseBiometrics: canEvaluateResult.canEvaluate,
            biometricsImage: biometricsImage
        )
    }
}

