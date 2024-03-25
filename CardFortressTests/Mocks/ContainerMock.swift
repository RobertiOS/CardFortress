//
//  ContainerMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/17/23.
//

@testable import CardFortress
import Swinject
import Foundation
import MockSupport
import CFDomain

extension Container {
    static let mockContainer: Container = {
        let container = Container(defaultObjectScope: .container)

        container.register(AuthenticationAPI.self) { r in
            Authentication(
                secureUserDataAPI: SecureUserDataAPIMock(),
                biometricsAPI: BiometricAuthAPIMock(),
                authDataSourceAPI: AuthDataSourceAPIMock(),
                container: container
            )
        }
        
        container.register(SecureUserDataAPI.self) { r in
            SecureUserDataAPIMock()
        }
        
        container.register(GetCreditCardUseCaseProtocol.self) { _ in
            GetCreditCardUseCaseMock()
        }
        
        container.register(GetCreditCardsUseCaseProtocol.self) { _ in
            GetCreditCardsUseCaseMock()
        }
        
        container.register(RemoveCreditCardUseCaseProtocol.self) { _ in
           RemoveCreditCardUseCaseMock()
        }
        
        container.register(AddCreditCardsUseCaseProtocol.self) { _ in
           AddCreditCardsUseCaseMock()
        }
        
        container.register(AddCreditCardAPI.self) { r in
           AddCreditCardAPIImpl(container: container)
        }
        
        container.register(CardListAPI.self) { r in
            CardListAPIImpl(container: container)
        }
        return container
    }()
}


