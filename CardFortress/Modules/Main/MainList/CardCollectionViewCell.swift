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
        label.textAlignment = .center
        return label
    }()
    
    private let cardNumber: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        addAutolayoutSubviews(titleLabel, cardNumber)
        
        NSLayoutConstraint.activate([
            
            cardNumber.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            cardNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
            
        ])
    }
    
    func configure(with creditCard: CreditCard) {
        titleLabel.text = creditCard.name
        cardNumber.text = "/(creditCard.number)"
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
