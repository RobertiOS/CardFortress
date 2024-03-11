//
//  SceneDelegate+Setup.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import Foundation
import UIKit
import CFAPIs
import Swinject
import CFDomain

extension SceneDelegate {
    func getDIContainer() -> Container {
        
        let containerMock: Container = {
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
            
            container.register(AddCreditCardAPI.self) { r in
               AddCreditCardAPIImpl(container: container)
            }
            
            container.register(CardListAPI.self) { r in
                CardListAPIImpl(container: container)
            }
            
            return container
        }()
        
        let appContainer: Container = {
            let container = Container(defaultObjectScope: .container)

            //MARK: Card list service
            
            let secureStore = SecureStore()
            
            let repository = FireBaseRepository()
            
            container.register(GetCreditCardUseCase.self) { _ in
                GetCreditCardUseCase(repository: repository)
            }
            
            container.register(GetCreditCardUseCaseProtocol.self) { _ in
                GetCreditCardUseCase(repository: repository)
            }
            
            container.register(GetCreditCardsUseCaseProtocol.self) { _ in
                GetCreditCardsUseCase(repository: repository)
            }
            
            container.register(RemoveCreditCardUseCaseProtocol.self) { _ in
                RemoveCreditCardUseCase(repository: repository)
            }
            
            container.register(AddCreditCardsUseCaseProtocol.self) { _ in
                AddCreditCardsUseCase(repository: repository)
            }
            
            let authDataSource = AuthDataSource()

            container.register(SecureUserDataAPI.self) { r in
                SecureUserData()
            }
            
            container.register(AddCreditCardAPI.self) { r in
                AddCreditCardAPIImpl(container: container)
            }
            
            container.register(CardListAPI.self) { r in
                CardListAPIImpl(container: container)
            }
            
            container.register(AuthenticationAPI.self) { r in
                Authentication(authDataSourceAPI: authDataSource, container: container)
            }
            
            return container
        }()

        return CommandLine.arguments.contains("-UITests") ?
        containerMock :
        appContainer
    }
}
