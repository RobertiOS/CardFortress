//
//  SceneDelegate+Setup.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import Foundation
import UIKit

extension SceneDelegate {
    func setUpDependencies() {

        //MARK: service
        let secureStore = SecureStore(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
        container.register(CardListServiceProtocol.self) { r in
            CardListService(secureStore: secureStore)
        }

        container.register(AuthenticationAPI.self) { r in
            Authentication()
        }
        
    }
    
    func setUpMockDependencies() {
        container.register(CardListServiceProtocol.self) { r in
            MockListService()
        }

        container.register(AuthenticationAPI.self) { r in
            AuthenticationAPIMock()
        }
        
        container.register(AuthenticationAPI.self) { r in
            AuthenticationAPIMock()
        }
    }
}
