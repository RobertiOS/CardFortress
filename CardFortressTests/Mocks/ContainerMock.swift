//
//  ContainerMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 12/17/23.
//

@testable import CardFortress
import Swinject
import Foundation

extension Container {
    static let mockContainer: Container = {
        let container = Container()
        container.register(CardListServiceProtocol.self) { r in
            MockListService()
        }
        
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
        
        container.register(AddCreditCardAPI.self) { r in
           AddCreditCardAPIImpl(container: container)
        }
        
        container.register(CardListAPI.self) { r in
            CardListAPIImpl(container: container)
        }
        return container
    }()
}


