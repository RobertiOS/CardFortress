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

extension SceneDelegate {
    func getDIContainer() -> Container {
        
        let containerMock: Container = {
            let container = Container(defaultObjectScope: .container)

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
        
        let appContainer: Container = {
            let container = Container(defaultObjectScope: .container)

            //MARK: Card list service
            
            let secureStore = SecureStore()
            container.register(CardListServiceProtocol.self) { r in
                CardListService(secureStore: secureStore)
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
