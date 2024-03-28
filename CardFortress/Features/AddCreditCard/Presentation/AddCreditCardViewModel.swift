//
//  AddCreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import Foundation
import Combine
import Domain


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
        var creditCardNumber: String?
        
        @Published
        var creditCardDate: String?
        
        @Published
        var creditCardHolderName: String?
        
        let action: AddCreditCardCoordinator.Action

        private var subscriptions = Set<AnyCancellable>()
        private let addCreditCardUseCase: AddCreditCardsUseCaseProtocol
        
        //MARK: - Initialization
        
        init(
            addCreditCardUseCase: AddCreditCardsUseCaseProtocol,
            action: AddCreditCardCoordinator.Action = .addCreditCard
        ) {
            self.addCreditCardUseCase = addCreditCardUseCase
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
        func createAddCreditCardPublisher() -> AnyPublisher<Void, Error>? {
            guard let creditCardDate,
                  let creditCardNumber else { return nil }
            
            return Future<Void, Error> { [weak self] promise in
                guard let self else { return }
                let creditCard: DomainCreditCard
                
                switch action {
                case .addCreditCard:
                    creditCard = .init(
                        identifier: UUID(),
                        number: creditCardNumber,
                        cvv: 123,
                        date: creditCardDate,
                        cardName: creditCardName ?? "",
                        cardHolderName: creditCardHolderName ?? "",
                        notes: "",
                        isFavorite: false
                    )
                case .editCreditCard(let card):
                    creditCard = .init(
                        identifier: card.identifier,
                        number: creditCardNumber,
                        cvv: 123,
                        date: creditCardDate,
                        cardName: creditCardName ?? "",
                        cardHolderName: creditCardHolderName ?? "",
                        notes: "",
                        isFavorite: false
                    )
                }
                
                Task { [weak self] in
                    do {
                        try await self?.addCreditCardUseCase.execute(creditCard: creditCard)
                        promise(.success(()))
                    } catch {
                        promise(.failure(NSError(domain: "Add CC View Controller", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while Adding or Editing the CC"])))
                    }
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
        
        func createAddCreditCardPublisher() -> AnyPublisher<Void, Error>? {
            target.createAddCreditCardPublisher()
        }
    }
}
