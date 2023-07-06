//
//  CardCollectionViewCell.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import UIKit
import CreditCardValidator

final class CardCollectionViewCell: UICollectionViewCell {
    
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
        label.font = UIFont(name: Constants.fontName, size: 20.0)!
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
        imageView.image = UIImage(named: Constants.chipImage)
        return imageView
    }()
    
    private lazy var copyCardNumberButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(copyCardNumberToClipboard), for: .touchUpInside)
        button.setImage(UIImage(named: Constants.copyImage), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private let cardTypeImageView = UIImageView()
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
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
            copyCardNumberButton
        }
    }
    
    //MARK: - view construction
    
    private func setupViews() {
        contentView.isUserInteractionEnabled = false
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        addAutoLayoutSubviews {
            cardNameLabel
            cardNumberLabel
            dateLabel
            cardHolderNameLabel
            chipImageView
            cardTypeImageView
            copyCardNumberButton
        }
        
        NSLayoutConstraint.activate([
            
            cardNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cardNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cardNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            chipImageView.heightAnchor.constraint(equalToConstant: 50),
            chipImageView.widthAnchor.constraint(equalToConstant: 65),
            chipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            chipImageView.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 10),
            
            cardNumberLabel.topAnchor.constraint(equalTo: chipImageView.bottomAnchor, constant: 10),
            cardNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardNumberLabel.heightAnchor.constraint(equalToConstant: 30),
            
            copyCardNumberButton.topAnchor.constraint(equalTo: cardNumberLabel.topAnchor),
            copyCardNumberButton.leadingAnchor.constraint(equalTo: cardNumberLabel.trailingAnchor, constant: 5),
            copyCardNumberButton.heightAnchor.constraint(equalToConstant: 30),
            copyCardNumberButton.widthAnchor.constraint(equalToConstant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            cardTypeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cardTypeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            
//            cvvLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            cvvLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
    //MARK: - Configutation
    
    public func configure(with creditCard: CreditCard) {
        cardNameLabel.text = creditCard.cardName
        cardNumberLabel.attributedText = getformatedTextTextForCreditCardNumber(cardNumber: creditCard.number)
        dateLabel.text = "\(creditCard.date)"
        cardHolderNameLabel.text = "\(creditCard.cardHolderName.uppercased())"
        cvvLabel.text = "\(creditCard.cvv)"
        if let image = CreditCardValidator(String(creditCard.number)).type?.icon {
        cardTypeImageView.image = image.aspectFittedToHeight(65)
        }
    }
    
    private func getformatedTextTextForCreditCardNumber(cardNumber: Int) -> NSAttributedString {
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
    
    //MARK: actions
    
    @objc
    private func copyCardNumberToClipboard() {
        UIPasteboard.general.string = self.cardNumberLabel.text
        UIView.animate(withDuration: 0.2) { [unowned self] in
            copyCardNumberButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                copyCardNumberButton.transform = CGAffineTransform.identity
            })
        }
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardCollectionViewCell {
    struct TestHooks {
        let target: CardCollectionViewCell
        var cardNameText: String? {
            target.cardNameLabel.text
        }
        
        var cardNumberLabelText: String? {
            target.cardNumberLabel.text
        }
        
        var dateLabelText: String? {
            target.dateLabel.text
        }
        
        var cardHolderNameText: String? {
            target.cardHolderNameLabel.text
        }
        
        var cvvLabelText: String? {
            target.cvvLabel.text
        }
        
        var chipImage: UIImage? {
            target.chipImageView.image
        }
        
        var cardTypeImage: UIImage? {
            target.cardTypeImageView.image
        }
        
        var copyCardNumberButton: UIButton {
            target.copyCardNumberButton
        }
        
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif
