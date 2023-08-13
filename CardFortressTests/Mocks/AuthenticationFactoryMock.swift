//
//  AuthenticationFactoryMock.swift
//  CardFortressTests
//
//  Created by Roberto Corrales on 8/5/23.
//

import UIKit
@testable import CardFortress

final class AuthenticationFactoryMock: AuthenticationFactoryProtocol {
    
    let loginViewController = UIViewController()
    
    func makeLoginViewController(delegate: CardFortress.LoginViewDelegate?) -> UIViewController {
        loginViewController
    }
    
}
