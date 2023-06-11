//
//  AddCreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import Foundation
import Swinject

protocol AddCreditCardViewModelProtocol {
    
}

extension AddCreditCardViewController {
    final class ViewModel: AddCreditCardViewModelProtocol {
        private let service: CardListServiceProtocol
        init(service: CardListServiceProtocol) {
            self.service = service
        }
    }
}
