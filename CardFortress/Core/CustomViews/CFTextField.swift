//
//  CFTextField.swift
//  CardFortress
//
//  Created by Roberto Corrales on 7/16/23.
//

import UIKit

final class CFTextField: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    let viewModel: ViewModel
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.labelText
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var errorTextLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.errorTextLabel
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = viewModel.font
        textField.layer.borderColor = viewModel.color.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.placeholder = viewModel.placeHolder
        textField.tag = viewModel.tag
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.keyboardType = viewModel.keyboardType
        return textField
    }()
    
    private let stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        construct()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func construct() {
        textField.delegate = delegate
        constructViewHerarchy()
        constructConstraints()
    }
    
    private func constructViewHerarchy() {
        stackContainer.addArrangedSubviews {
            textLabel
            textField
            errorTextLabel
        }
        
        stackContainer.setCustomSpacing(10, after: textLabel)
        stackContainer.setCustomSpacing(5, after: textField)
        
        addAutoLayoutSubviews {
            stackContainer
        }
    }
    
    private func constructConstraints() {
        activateConstraints {
            stackContainer.topAnchor.constraint(equalTo: topAnchor)
            stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor)
            stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
            stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            textField.heightAnchor.constraint(equalToConstant: 50)
        }
    }
    
    public func setErrorVisible(visible: Bool) {
        errorTextLabel.isHidden = !visible
    }
    
    public var text: String? {
        get {
            textField.text
        }
        
        set {
            textField.text = newValue
        }
    }
    
    public var placeHolder: String? {
        textField.placeholder
    }
    
    public var labelText: String? {
        textLabel.text
    }

}

extension CFTextField {
    final class ViewModel {
        let placeHolder: String
        let font: UIFont
        let labelText: String
        let color: UIColor
        let tag: Int
        let errorTextLabel: String
        let keyboardType: UIKeyboardType
        
        init(
            placeHolder: String = "",
            font: UIFont = UIFont.systemFont(ofSize: 20),
            labelText: String = "",
            color: UIColor = .gray,
            tag: Int = 0,
            errorTextLabel: String = LocalizableString.cfTextFieldGenericErrorMessage,
            keyboardType: UIKeyboardType = .default
            ) {
                self.placeHolder = placeHolder
                self.font = font
                self.labelText = labelText
                self.color = color
                self.tag = tag
                self.errorTextLabel = errorTextLabel
                self.keyboardType = keyboardType
            }
        
    }
}

extension CFTextField {
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    struct TestHooks {
        let target: CFTextField
        
        init(target: CFTextField) {
            self.target = target
        }
        
        var textField: UITextField {
            target.textField
        }
        
        var label: UILabel {
            target.textLabel
        }
        
        var errorLabel: UILabel {
            target.errorTextLabel
        }
        
        var placeHolder: String? {
            target.placeHolder
        }
        
        var labelText: String? {
            target.labelText
        }
    }
}
