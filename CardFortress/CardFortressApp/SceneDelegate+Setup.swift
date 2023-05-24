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
        let secureStorePOC = SecureStorePOC(sSQueryable: CreditCardSSQueryable(service: "CreditCards"))
        container.register(CardListServiceProtocol.self) { r in
            CardListService(secureStorePOC: secureStorePOC)
        }
    }
}
