//
//  PreviewCreditCardView.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/27/23.
//

import UIKit
import CreditCardValidator
import Combine

final class PreviewCreditCardView: UIView {

    //MARK: - Constants

    private struct Constants {
        static let fontName = "Credit Card"
        static let copyImage = "CopyImage"
        static let chipImage = "chip"
    }
    
    //MARK: Properties
    
    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 15.0)!
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let cardHolderNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20.0)!
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let cvvLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let chipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.chipImage)?.aspectFittedToHeight(40)
        
        return imageView
    }()
    
    private let cardTypeImageView = UIImageView()
    
    var viewModel: ViewModel
    
    var subscription: AnyCancellable?
    
    //MARK: - Initialization
    
    init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindSubscritions()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @SubviewBuilder
    var views: [UIView] {
        get {
            cardNameLabel
            cardNumberLabel
            dateLabel
            cardHolderNameLabel
            chipImageView
            cardTypeImageView
        }
    }
    
    //MARK: - view construction
    
    private func setupViews() {
        addAutoLayoutSubviews {
            cardNameLabel
            cardNumberLabel
            dateLabel
            cardHolderNameLabel
            chipImageView
            cardTypeImageView
        }
        
        addConstraints {
            cardNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            cardNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            cardNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            cardNameLabel.heightAnchor.constraint(equalToConstant: 20)
            
            chipImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            chipImageView.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 10)
            
            cardNumberLabel.topAnchor.constraint(equalTo: chipImageView.bottomAnchor, constant: 10)
            cardNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            cardNumberLabel.heightAnchor.constraint(equalToConstant: 30)
            
            dateLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 10)
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100)
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            
            cardTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            cardTypeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
    
    //MARK: Subscriptions
    
    private func bindSubscritions() {
        subscription = viewModel.shouldUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.layoutSubviews()
                self.cardNameLabel.text = self.viewModel.name
                if let number = self.viewModel.number,
                   let image = CreditCardValidator(String(number)).type?.icon {
                    self.cardTypeImageView.image = image.aspectFittedToHeight(45)
                }
                self.cardNumberLabel.attributedText = self.getformatedTextTextForCreditCardNumber(cardNumber: self.viewModel.number)
                self.dateLabel.text = self.viewModel.date
                self.cardHolderNameLabel.text = self.viewModel.holderName?.uppercased()
                
            }
    }
    
    private func getformatedTextTextForCreditCardNumber(cardNumber: String?) -> NSAttributedString? {
        guard let cardNumber = cardNumber?.replacingOccurrences(of: " ", with: "") else { return nil }
        var formatedText = ""
        for (i, c) in "\(cardNumber)".enumerated() {
            if i > 0 && i % 4 == 0 {
                formatedText += " "
            }
            formatedText.append(c)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.kern: 5,
            NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: 14.0)!
        ]
        let attributedText = NSAttributedString(string: formatedText, attributes: attributes)
        return attributedText
    }
}


extension PreviewCreditCardView {
    final class ViewModel {
        var number: String? {
            didSet {
                shouldUpdate.send()
            }
        }
        var name: String? {
            didSet {
                shouldUpdate.send()
            }
        }
        var holderName: String? {
            didSet {
                shouldUpdate.send()
            }
        }
        var date: String? {
            didSet {
                shouldUpdate.send()
            }
        }
        var shouldUpdate: PassthroughSubject<Void, Never> = .init()
    }
}
