//
//  CardCollectionViewCell.swift
//  CardFortress
//
//  Created by Roberto Corrales on 19/04/23.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let cardNumber: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let cardHolderNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
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
        
        addAutolayoutSubviews(titleLabel, cardNumber, dateLabel, cardHolderNameLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            cardNumber.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            cardNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardNumber.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
            
        ])
    }
    
    func configure(with creditCard: CreditCard) {
        titleLabel.text = creditCard.cardName
        cardNumber.attributedText = getTextForCreditCardNumber(cardNumber: creditCard.number)
        dateLabel.text = "\(creditCard.date)"
        cardHolderNameLabel.text = "\(creditCard.cardHolderName)"
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
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]

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
