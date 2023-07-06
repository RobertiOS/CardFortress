//
//  AddCreditCardViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import Foundation
import Combine

protocol AddCreditCardViewModelProtocol {
   
    var creditCardName: String? { get set }
    var creditCardNumber: String? { get set }
    var creditCardDate: String? { get set }
    var creditCardHolderName: String? { get set }
    var shouldUpdateView: PassthroughSubject<Void, Never> { get }
    func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>?
}

enum AddCreditCardResult {
    case success
    case failure(Error)
}

extension AddCreditCardViewController {
    
    final class ViewModel: AddCreditCardViewModelProtocol {
        
        //MARK: - Properties
        
        var creditCardName: String? {
            didSet {
                if oldValue != creditCardName {
                    shouldUpdateView.send()
                }
            }
        }
        
        var creditCardNumber: String? {
            didSet {
                if oldValue != creditCardNumber {
                    shouldUpdateView.send()
                }
            }
        }
        var creditCardDate: String? {
            didSet {
                if oldValue != creditCardDate {
                    shouldUpdateView.send()
                }
            }
        }
        var creditCardHolderName: String? {
            didSet {
                if oldValue != creditCardHolderName {
                    shouldUpdateView.send()
                }
            }
        }
        
        var shouldUpdateView: PassthroughSubject<Void, Never> = .init()

        private var subscriptions = Set<AnyCancellable>()
        private let service: CardListServiceProtocol
        
        //MARK: - Initialization
        
        init(service: CardListServiceProtocol) {
            self.service = service
        }
        
        //MARK: - Methods
        func createAddCreditCardPublisher() -> AnyPublisher<AddCreditCardResult, Error>? {
            guard let creditCardDate,
                  let creditCardNumber = creditCardNumber?.replacingOccurrences(of: " ", with: ""),
                  let creditCardInt = Int(creditCardNumber) else { return nil }
            let creditCard: CreditCard = .init(
                number: creditCardInt,
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
