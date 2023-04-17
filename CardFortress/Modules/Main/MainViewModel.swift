//
//  MainViewModel.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func increaseQuantity()
    var quantity: Observable<Int> { get set }
    //navigation
    func goToOtherVC()
}

final class MainViewModel {
    var quantity: Observable<Int>  = .init(0)
    weak var delegate: MainCoordinatorDelegate?
}

extension MainViewModel: MainViewModelProtocol {
    
    func increaseQuantity() {
        quantity.value += 1
    }
    
    func goToOtherVC() {
        delegate?.presentAnotherVC()
    }
}
