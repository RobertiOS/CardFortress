//
//  AddCreditCardViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import UIKit

protocol AddCreditCardViewControllerProtocol {
    
}

final class AddCreditCardViewController: UIViewController, AddCreditCardViewControllerProtocol {

    //MARK: - properties
    
    private var numberTextField: UITextField = {
       let textField = CFTextField()
        textField.placeholder = "Credit card number"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.paddingValue = 10
        textField.borderColor = .gray
        textField.borderWidth = 1
        textField.cornerRadius = 10
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Expiration Date:"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private var cardNameTextField: UITextField = {
       let textField = CFTextField()
        textField.placeholder = "credit card name: e.g: Bank Name"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.paddingValue = 10
        textField.borderColor = .gray
        textField.borderWidth = 1
        textField.cornerRadius = 10
        return textField
    }()
    
    private let expirationDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private var cardHolderNameTextField: UITextField = {
       let textField = CFTextField()
        textField.placeholder = "card holder name: e.g: Juan Perez"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.paddingValue = 10
        textField.borderColor = .gray
        textField.borderWidth = 1
        textField.cornerRadius = 10
        return textField
    }()
    
    private var cvvTextField: UITextField = {
       let textField = CFTextField()
        textField.placeholder = "The code on the back of your card"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.paddingValue = 10
        textField.borderColor = .gray
        textField.borderWidth = 1
        textField.cornerRadius = 10
        return textField
    }()
    
    private let viewModel: AddCreditCardViewModelProtocol
    
    //MARK: - Initialization
    
    init(viewModel: AddCreditCardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constructViewHerarchy()
        setUpConstraints()
    }
    
    //MARK: - View Construction
    
    private func constructViewHerarchy() {
        view.addAutoLayoutSubviews {
            numberTextField
            dateLabel
            expirationDatePicker
            cardNameTextField
            cardHolderNameTextField
        }
    }
    
    private func setUpConstraints() {
        view.addConstraints {
            
            /// card number
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            numberTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
            numberTextField.heightAnchor.constraint(equalToConstant: 40)
            
            /// date
            dateLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 10)
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            dateLabel.lastBaselineAnchor.constraint(equalTo: expirationDatePicker.lastBaselineAnchor)
            
            expirationDatePicker.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10)
            expirationDatePicker.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -10)
            expirationDatePicker.topAnchor.constraint(equalTo: dateLabel.topAnchor)
            expirationDatePicker.heightAnchor.constraint(equalToConstant: 40)
            
            /// card holder name
            cardHolderNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            cardHolderNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            cardHolderNameTextField.topAnchor.constraint(equalTo: expirationDatePicker.bottomAnchor, constant: 10)
            cardHolderNameTextField.heightAnchor.constraint(equalToConstant: 40)
            
            /// cardName
            cardNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            cardNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            cardNameTextField.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 10)
            cardNameTextField.heightAnchor.constraint(equalToConstant: 40)
        }
    }
}
