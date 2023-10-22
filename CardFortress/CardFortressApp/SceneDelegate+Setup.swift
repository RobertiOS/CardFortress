//
//  SceneDelegate+Setup.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import Foundation
import UIKit
import CFHelper
import Swinject

extension SceneDelegate {
    func getDIContainer() -> Container {
        
        let containerMock: Container = {
            let container = Container()

            container.register(CardListServiceProtocol.self) { r in
                MockListService()
            }

            container.register(AuthenticationAPI.self) { r in
                AuthenticationAPIMock()
            }
            
            container.register(AuthenticationAPI.self) { r in
                AuthenticationAPIMock()
            }
            
            container.register(SecureUserDataAPI.self) { r in
                SecureUserDataAPIMock()
            }
            
            return container
        }()
        
        let appContainer: Container = {
            let container = Container()

            //MARK: Card list service
            
            let secureStore = SecureStore()
            container.register(CardListServiceProtocol.self) { r in
                CardListService(secureStore: secureStore)
            }
            
            let authDataSource = AuthDataSource()

            container.register(AuthenticationAPI.self) { r in
                Authentication(authDataSourceAPI: authDataSource)
            }
            
            container.register(SecureUserDataAPI.self) { r in
                SecureUserData()
            }
            
            return container
        }()

        return CommandLine.arguments.contains("-UITests") ?
        containerMock :
        appContainer
    }
}
