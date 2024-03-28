//
//  ListViewModelProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation
import Combine
import Domain

protocol ListViewModelProtocol: AnyObject {
    var itemsPublisher: AnyPublisher<[DomainCreditCard], Error> { get }
    func fetchCreditCards()
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func deleteCreditCard(_ creditCardIdentifier: UUID)
}

final class ListViewModel: ListViewModelProtocol {
    private var subscriptions = Set<AnyCancellable>()
    private let itemsSubject = PassthroughSubject<[DomainCreditCard], Error>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    private let getCreditCardsUseCase: GetCreditCardsUseCaseProtocol
    private let removeCreditCardUseCase: RemoveCreditCardUseCaseProtocol
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    var itemsPublisher: AnyPublisher<[DomainCreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }
    
    public init(
        getCreditCardsUseCase: any GetCreditCardsUseCaseProtocol,
        removeCreditCardUseCase: any RemoveCreditCardUseCaseProtocol
    ) {
        self.getCreditCardsUseCase = getCreditCardsUseCase
        self.removeCreditCardUseCase = removeCreditCardUseCase
    }
    
    func fetchCreditCards() {
        isLoadingSubject.send(true)
        Task {
            do {
                let creditCards = try await getCreditCardsUseCase.execute()
                itemsSubject.send(creditCards)
            } catch {
                itemsSubject.send(
                    completion: .failure(
                        NSError(domain: "CC list VM", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while fetching the credit cards"])
                    )
                )
            }
        }
    }
    
    func deleteCreditCard(_ creditCardIdentifier: UUID) {
        Task {
            do {
                let creditCards = try await removeCreditCardUseCase.execute(identifier: creditCardIdentifier)
                itemsSubject.send(creditCards)
            } catch {
                itemsSubject.send(
                    completion: .failure(
                        NSError(domain: "CC list VM", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error while Deleting the credit card"])
                    )
                )
            }
        }
    }
}

