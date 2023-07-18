//
//  ImageParser.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/18/23.
//

import UIKit
import Vision
import VisionKit

// MARK: - Add unit tests

protocol ImageParserProtocol {
    func mapUIImageToCreditCard(image: UIImage?) async -> CreditCard?
}

final class ImageParser: ImageParserProtocol {
    func mapUIImageToCreditCard(image: UIImage?) async -> CreditCard? {
        guard let cgImage = image?.cgImage else { return nil }
        
        var recognizedText = [String]()
        let ingoreList2 = ["MasterCard", "Visa", "Amex", "Discover", "Diner's Club/Carte Blanche"]
        var textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ingoreList2 + ["Expiry Date"]
        return await withCheckedContinuation { continuation in
            textRecognitionRequest = VNRecognizeTextRequest() { (request, error) in
                guard let results = request.results,
                      !results.isEmpty,
                      let requestResults = request.results as? [VNRecognizedTextObservation]
                else { return continuation.resume(returning: nil) }
                recognizedText = requestResults.compactMap { observation in
                    return observation.topCandidates(1).first?.string
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
                continuation.resume(returning: parseResults(for: recognizedText))
            } catch {
                print(error)
            }
        }
    }
    
    func parseResults(for recognizedText: [String]) -> CreditCard {
        // Credit Card Number
        let creditCardNumber = recognizedText.first(where: { $0.count >= 14 && ["4", "5", "3", "6"].contains($0.first) })
        
        // Expiry Date
        let expiryDateString = recognizedText.first(where: { $0.count > 4 && $0.contains("/") })
        let expiryDate = expiryDateString?.filter({ $0.isNumber || $0 == "/" })
        
        // Name
        let ignoreList = ["GOOD THRU", "GOOD", "THRU", "Gold", "GOLD", "Standard", "STANDARD", "Platinum", "PLATINUM", "WORLD ELITE", "WORLD", "ELITE", "World Elite", "World", "Elite"]
        let ingoreList2 = ["MasterCard", "Visa", "Amex", "Discover", "Diner's Club/Carte Blanche"]
        let wordsToAvoid = [creditCardNumber, expiryDateString] +
        ignoreList +
        ingoreList2 +
        ingoreList2.map { $0.lowercased() } +
        ingoreList2.map { $0.uppercased() }
        let name = recognizedText.filter({ !wordsToAvoid.contains($0) }).last
        
        let creditCard = CreditCard(
            number: Int(creditCardNumber?.replacingOccurrences(of: " ", with: "") ?? "0") ?? 0,
            cvv: 123,
            date: expiryDate ?? "",
            cardName: name ?? "",
            cardHolderName: ""
        )
        
        return creditCard
    }
}
