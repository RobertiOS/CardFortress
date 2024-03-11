//
//  ListViewModelProtocol.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation
import Combine

protocol ListViewModelProtocol: AnyObject {
    var itemsPublisher: AnyPublisher<[CreditCard], Error> { get }
    func fetchCreditCards()
    var cardListService: CardListServiceProtocol { get set }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    /// this function can add or update a card
    func addCreditCard(_ creditCard: CreditCard)
    func deleteCreditCard(_ creditCardIdentifier: UUID)
    func deleteAllCards()
}

final class ListViewModel: ListViewModelProtocol {
    private var subscriptions = Set<AnyCancellable>()
    var cardListService: CardListServiceProtocol
    private let itemsSubject = PassthroughSubject<[CreditCard], Error>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(cardListService: CardListServiceProtocol) {
        self.cardListService = cardListService
    }

    var itemsPublisher: AnyPublisher<[CreditCard], Error> {
        itemsSubject.eraseToAnyPublisher()
    }
    
    func addCreditCard(_ creditCard: CreditCard) {
        cardListService.addCreditCardToSecureStore(creditCard)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.itemsSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.fetchCreditCards()
                case .failure(let error):
                    self?.itemsSubject.send(completion: .failure(error))
                default:
                    break
                }
            }
            .store(in: &subscriptions)
    }

    func fetchCreditCards() {
        isLoadingSubject.send(true)
        cardListService.getCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.itemsSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] cards in
                self?.itemsSubject.send(cards)
            }
            .store(in: &subscriptions)
    }
    
    func deleteAllCards() {
        cardListService.deleteAllCreditCardsFromSecureStore()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.itemsSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] status in
                self?.itemsSubject.send([])
            }
            .store(in: &subscriptions)
    }
    
    func deleteCreditCard(_ creditCardIdentifier: UUID) {
        cardListService.deleteCreditCardFromSecureStore(creditCardIdenfitifer: creditCardIdentifier)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.itemsSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] cards in
                self?.itemsSubject.send(cards)
            }
            .store(in: &subscriptions)
    }
}

