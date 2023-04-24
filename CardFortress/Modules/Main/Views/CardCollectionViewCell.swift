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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
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
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
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
