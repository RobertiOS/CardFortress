//
//  UITextField+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/16/23.
//

import UIKit

extension UITextField {
    func addBottomBorder(height: CGFloat = 2.0, color: UIColor = .blue.withAlphaComponent(0.05)) {
            let borderView = UIView()
            borderView.backgroundColor = color
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            NSLayoutConstraint.activate(
                [
                    borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    borderView.heightAnchor.constraint(equalToConstant: height)
                ]
            )
        }
}
