//
//  AddCreditCardViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import UIKit
import Combine

protocol AddCreditCardViewControllerProtocol: UIViewController {
    var viewModel: AddCreditCardViewModelProtocol { get set }
    var delegate: AddCreditCardCoordinatorDelegate? { get set }
}

final class AddCreditCardViewController: UIViewController, AddCreditCardViewControllerProtocol {

    //MARK: - subviews
    
    @CCTextField(placeHolder: LocalizableString.cardNumberPlaceHolder.value, tag: 1)
     var numberTextField: UITextField = UITextField()
    
    @CCTextField(placeHolder: LocalizableString.cardNamePlaceHolder.value, tag: 2)
    private var cardNameTextField: UITextField = UITextField()
    
    @CCTextField(placeHolder: LocalizableString.cardHolderNamePlaceHolder.value, tag: 3)
    private var cardHolderNameTextField: UITextField = UITextField()
    
    @CCTextField(placeHolder: LocalizableString.expirationDatePlaceHolder.value, tag: 3)
    private var expirationDateTextField: UITextField = UITextField()
    
    private lazy var addCreditCardButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableString.addCreditCardButtonTitle.value, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.addAction(addAction, for: .touchUpInside)
        return button
    }()
    
    private lazy var addAction: UIAction = .init { [weak self] _ in
        guard let self else { return }
        self.viewModel.createAddCreditCardPublisher()?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                //TODO: hanlde completion
            }, receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    UIAlertController.Builder()
                        .withTitle("Info")
                        .withMessage("The Card Was Added Successfuly")
                        .withButton(title: "OK")
                        .present(in: self)
                    
                   
                case .failure(let error):
                    UIAlertController.Builder()
                        .withTitle("Error")
                        .withMessage(error.localizedDescription)
                        .present(in: self)
                }
            })
            .store(in: &self.subscriptions)
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.expirationDateLabel.value
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let creditCardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.cardNumberLabel.value
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let holderNameLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.cardHolderNameLabel.value
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let creditCardNameLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.cardNameLabel.value
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: AddCreditCardCoordinatorDelegate?
    
    private let previewCreditCardView = PreviewCreditCardView()
    
    var viewModel: AddCreditCardViewModelProtocol
    
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
        setUpSubscriptions()
    }
    
    //MARK: - View Construction
    
    private func constructViewHerarchy() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera.viewfinder"), style: .plain, target: self, action: #selector(startVisionVC))
        title = LocalizableString.addCreditCardTitle.value
        
        [
            numberTextField,
            cardNameTextField,
            cardHolderNameTextField,
            expirationDateTextField
        ].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        numberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addAutoLayoutSubviews {
            ///preview
            previewCreditCardView
            
            ///textField
            numberTextField
            cardNameTextField
            cardHolderNameTextField
            expirationDateTextField
            
            ///labels
            creditCardNameLabel
            creditCardNumberLabel
            holderNameLabel
            dateLabel
            
            ///buton
            addCreditCardButton
        }
    }
    
    private func setUpConstraints() {
        view.addConstraints {
            
            /// credit card preview
            previewCreditCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
            previewCreditCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
            previewCreditCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
            previewCreditCardView.heightAnchor.constraint(equalToConstant: 200)
            /// card number

            creditCardNumberLabel.topAnchor.constraint(equalTo: previewCreditCardView.bottomAnchor, constant: 50)
            creditCardNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            creditCardNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10)
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            numberTextField.topAnchor.constraint(equalTo: creditCardNumberLabel.bottomAnchor, constant: 10)
            numberTextField.heightAnchor.constraint(equalToConstant: 40)
            
            /// date
            dateLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 15)
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            
            expirationDateTextField.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
            expirationDateTextField.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10)
            expirationDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            expirationDateTextField.heightAnchor.constraint(equalToConstant: 40)
    
            /// card holder name
            holderNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20)
            holderNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            holderNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10)
            
            cardHolderNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            cardHolderNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            cardHolderNameTextField.topAnchor.constraint(equalTo: holderNameLabel.bottomAnchor, constant: 10)
            cardHolderNameTextField.heightAnchor.constraint(equalToConstant: 40)
            
            /// cardName
            
            creditCardNameLabel.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 20)
            creditCardNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            creditCardNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10)
            
            cardNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            cardNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            cardNameTextField.topAnchor.constraint(equalTo: creditCardNameLabel.bottomAnchor, constant: 10)
            cardNameTextField.heightAnchor.constraint(equalToConstant: 40)
            
            /// add CD button
            addCreditCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
            addCreditCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            addCreditCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        }
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    //MARK: Combine Subscriptions
    
    func setUpSubscriptions() {
        viewModel.shouldUpdateView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.previewCreditCardView.viewModel.holderName = self.viewModel.creditCardHolderName
                self.previewCreditCardView.viewModel.name = self.viewModel.creditCardName
                self.previewCreditCardView.viewModel.date = self.viewModel.creditCardDate
                self.previewCreditCardView.viewModel.number = self.viewModel.creditCardNumber
                
                self.cardNameTextField.text = self.viewModel.creditCardName
                self.cardHolderNameTextField.text = self.viewModel.creditCardHolderName
                self.numberTextField.text = self.viewModel.creditCardNumber
                self.expirationDateTextField.text = self.viewModel.creditCardDate
                
            }.store(in: &subscriptions)
    }
    
    
    @objc
    func startVisionVC() {
        delegate?.startVisionKitCoordinator()
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case numberTextField:
            viewModel.creditCardNumber = textField.text
        case expirationDateTextField:
            viewModel.creditCardDate = textField.text
        case cardNameTextField:
            viewModel.creditCardName = textField.text
        case cardHolderNameTextField:
            viewModel.creditCardHolderName = textField.text
        default:
            return
        }
        
    }
    
    //MARK: - Helper functions
    
    func formatCreditCardNumber(_ number: String) -> String {
        var formattedNumber = ""
        number.enumerated().forEach { index, character in
            if index % 4 == 0 && index > 0 {
                formattedNumber.append(" ")
            }
            formattedNumber.append(character)
        }
        return formattedNumber
    }
}

extension AddCreditCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        case 2:
            viewModel.creditCardName = textField.text
        case 3:
            viewModel.creditCardHolderName = textField.text
        default:
            return false
        }
        return true
    }
}

extension AddCreditCardViewController {
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    
    struct TestHooks {
        let target: AddCreditCardViewController
        
        init(target: AddCreditCardViewController) {
            self.target = target
        }
        
        var numberTextField: UITextField {
            target.numberTextField
        }
        
        var nameTextField: UITextField {
            target.numberTextField
        }
        
        var cardHolderNameTextField: UITextField {
            target.cardHolderNameTextField
        }
        
        var expirationDateTextField: UITextField {
            target.expirationDateTextField
        }
        
        var cardNameTextField: UITextField {
            target.cardNameTextField
        }
        
        var cardNumberLabel: UILabel {
            target.creditCardNumberLabel
        }
        
        var expirationDateLabel: UILabel {
            target.dateLabel
        }
        
        var cardHolderLabel: UILabel {
            target.holderNameLabel
        }
        
        var cardNameLabel: UILabel {
            target.creditCardNameLabel
        }
        
        var addButton: UIButton {
            target.addCreditCardButton
        }
    }
}

