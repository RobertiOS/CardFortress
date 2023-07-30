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
}
