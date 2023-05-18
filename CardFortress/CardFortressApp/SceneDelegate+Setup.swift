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
        
        //MARK: service and secure store
        
        container.register(SecureStoreProtocol.self) { r in
            SecureStore(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
        }
        
        container.register(CardListServiceProtocol.self) { r in
            CardListService(secureStore: r.resolve(SecureStoreProtocol.self)!)
        }
    }
}
