//
//  AddCreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import Foundation
import Combine


enum AddCreditCardResult: Equatable {
    case success
    case editSuccess
    case addSuccess
    case failure(Error)
    
    static func ==(lhs: AddCreditCardResult, rhs: AddCreditCardResult) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case (.editSuccess, .editSuccess):
                return true
            case (.addSuccess, .addSuccess):
                return true
            case let (.failure(lhsError), .failure(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
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
        
        let action: AddCreditCardCoordinator.Action

        private var subscriptions = Set<AnyCancellable>()
        private let service: CardListServiceProtocol
        
        //MARK: - Initialization
        
        init(
            service: CardListServiceProtocol,
            action: AddCreditCardCoordinator.Action = .addCreditCard
        ) {
            self.service = service
            self.action = action
            
            setActionType()
        }
        
        func setActionType() {
            switch action {
            case .addCreditCard:
                return
            case .editCreditCard(let creditCard):
                self.creditCardDate = creditCard.date
                self.creditCardHolderName = creditCard.cardHolderName
                self.creditCardNumber = creditCard.number
                self.creditCardName = creditCard.cardName
            }
        }
        
        //MARK: - Methods
        func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>? {
            guard let creditCardDate,
                  let creditCardNumber else { return nil }
            let creditCard: CreditCard
            
            switch action {
            case .addCreditCard:
                creditCard = .init(
                    number: creditCardNumber,
                    cvv: 123,
                    date: creditCardDate,
                    cardName: creditCardName ?? "",
                    cardHolderName: creditCardHolderName ?? ""
                )
            case .editCreditCard(let card):
                creditCard = .init(
                    identifier: card.identifier,
                    number: creditCardNumber,
                    cvv: 123,
                    date: creditCardDate,
                    cardName: creditCardName ?? "",
                    cardHolderName: creditCardHolderName ?? ""
                )
            }
            return service.addCreditCardToSecureStore(creditCard)
                .receive(on: DispatchQueue.main)
                .map { (result: CardListServiceResult) -> (AddCreditCardResult) in
                    switch result {
                    case .success:
                        return .success
                    case .failure(let error):
                        return .failure(error)
                    case .addSuccess:
                        return .addSuccess
                    case .editSuccess:
                        return .editSuccess
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
