//
//  String+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/29/23.
//

import Foundation

extension String {
    public func grouping(every groupSize: Int, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
}
