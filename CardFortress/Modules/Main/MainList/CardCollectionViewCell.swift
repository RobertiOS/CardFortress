//
//  CardCollectionViewCell.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    struct Constants {
        static let fontName = "Credit Card"
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let cardNumber: UILabel = {
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
        imageView.image = UIImage(named: "chip")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        addAutolayoutSubviews([
            titleLabel,
            cardNumber,
            dateLabel,
            cardHolderNameLabel,
            cvvLabel,
            chipImageView
        ])
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            chipImageView.heightAnchor.constraint(equalToConstant: 50),
            chipImageView.widthAnchor.constraint(equalToConstant: 65),
            chipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            chipImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            cardNumber.topAnchor.constraint(equalTo: chipImageView.bottomAnchor, constant: 10),
            cardNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardNumber.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            cvvLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cvvLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
    func configure(with creditCard: CreditCard) {
        titleLabel.text = creditCard.cardName
        cardNumber.attributedText = getTextForCreditCardNumber(cardNumber: creditCard.number)
        dateLabel.text = "\(creditCard.date)"
        cardHolderNameLabel.text = "\(creditCard.cardHolderName.uppercased())"
        cvvLabel.text = "\(creditCard.cvv)"
    }
    
    func getTextForCreditCardNumber(cardNumber: Int) -> NSAttributedString {
        let texto = "\(cardNumber)"
        var formatedText = ""
        for (i, c) in texto.enumerated() {
            if i > 0 && i % 4 == 0 {
                formatedText += " "
            }
            formatedText.append(c)
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 5, NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: 18.0)!]

        let attributedText = NSAttributedString(string: formatedText, attributes: attributes)
        return attributedText
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardCollectionViewCell {
    struct TestHooks {
        let target: CardCollectionViewCell
        var textLabel: String {
            target.titleLabel.text ?? ""
        }
        
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif
