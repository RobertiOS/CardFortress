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
            AuthenticationAPIMock()
        }
        
        container.register(SecureUserDataAPI.self) { r in
            SecureUserDataAPIMock()
        }
        
        container.register(AddCreditCardAPI.self) { r in
            AddCreditCardAPIMock()
        }
        return container
    }()
}


