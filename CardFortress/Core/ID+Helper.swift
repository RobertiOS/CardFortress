//
//  ID+Helper.swift
//  CardFortress
//
//  Created by Roberto Corrales on 11/26/23.
//

import Foundation

struct ID<T>: Decodable, Hashable {
    let value: UUID = .init()
}
