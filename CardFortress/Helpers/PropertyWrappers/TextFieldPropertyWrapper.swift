//
//  TextFieldPropertyWrapper.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/26/23.
//

import UIKit

@propertyWrapper
struct CCTextField {
    private var textField: UITextField
    private let fontSize: CGFloat
    private let tag: Int
    private let placeHolder: String?
    
    var wrappedValue: UITextField {
        set {
            textField = newValue
        }
        get {
            textField.font = UIFont.systemFont(ofSize: fontSize)
            textField.addBottomBorder()
            textField.placeholder = placeHolder
            textField.tag = tag
            return textField
        }
    }
    
    init(wrappedValue: UITextField,
         fontSize: CGFloat = 20.0,
         placeHolder: String? = nil,
         tag: Int = 0) {
        self.textField = wrappedValue
        self.fontSize = fontSize
        self.tag = tag
        self.placeHolder = placeHolder
    }
}

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
