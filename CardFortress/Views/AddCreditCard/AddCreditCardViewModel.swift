//
//  AddCreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import Foundation
import Combine


enum AddCreditCardResult {
    case success
    case failure(Error)
}

extension AddCreditCardViewController {
    
    final class ViewModel {
        
        //MARK: - Properties
        @Published
        var creditCardName: String?
        
        @Published
        var creditCardNumber: Int?
        
        @Published
        var creditCardDate: String?
        
        @Published
        var creditCardHolderName: String?

        private var subscriptions = Set<AnyCancellable>()
        private let service: CardListServiceProtocol
        
        //MARK: - Initialization
        
        init(service: CardListServiceProtocol) {
            self.service = service
        }
        
        //MARK: - Methods
        func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>? {
            guard let creditCardDate,
                  let creditCardNumber else { return nil }
            let creditCard: CreditCard = .init(
                number: creditCardNumber,
                cvv: 123,
                date: creditCardDate,
                cardName: creditCardName ?? "",
                cardHolderName: creditCardHolderName ?? ""
            )
            return service.addCreditCardToSecureStore(creditCard)
                .receive(on: DispatchQueue.main)
                .map {
                    switch $0 {
                    case .success:
                        return AddCreditCardResult.success
                    case .failure(let error):
                        return AddCreditCardResult.failure(error)
                    }
                }
                .eraseToAnyPublisher()
        }
    }
}

extension AddCreditCardViewController.ViewModel {
    struct TestHooks {
        let target: AddCreditCardViewController.ViewModel
        
        init(target: AddCreditCardViewController.ViewModel) {
            self.target = target
        }
        
        func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>? {
            target.createAddCreditCardPublisher()
        }
    }
}
