//
//  CardListService.swift
//  CardFortress
//
//  Created by Roberto Corrales on 29/04/23.
//

import Foundation
import Combine

protocol CardListServiceProtocol {
    // for now it's returning an array of strings but in the future I will change this.
    func getCards() -> Future<[String], Error>
    func saveCart()
}


final class CardListService: CardListServiceProtocol {
    func getCards() -> Future<[String], Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                let number = Int.random(in: 1...10)
                promise(Result.success(["Tarjeta 1", "Tarjeta 2", "Tarjeta 3", "Tarjeta 4", "Tarjeta 5", "Tarjeta 6", "Tarjeta 7", "Tarjeta 8", "Tarjeta 9", "Tarjeta 10"]))
            }
        }
    }
    
    func saveCart() {
        // No operation
    }
    
    
}
