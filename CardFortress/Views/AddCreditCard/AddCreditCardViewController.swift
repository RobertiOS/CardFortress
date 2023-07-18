//
//  AddCreditCardViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import UIKit
import Combine

protocol AddCreditCardViewControllerProtocol: UIViewController {
    var viewModel: AddCreditCardViewController.ViewModel { get set }
    var delegate: AddCreditCardCoordinatorDelegate? { get set }
}

final class AddCreditCardViewController: UIViewController, AddCreditCardViewControllerProtocol {

    //MARK: - subviews
    
    private lazy var addCreditCardButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableString.addCreditCardButtonTitle.value, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.addAction(addAction, for: .touchUpInside)
        button.backgroundColor = UIColor.cfPurple
        return button
    }()
    
    private lazy var scanCardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle(LocalizableString.scanYourCard.value, for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addAction(addAction, for: .touchUpInside)
        var configuration = UIButton.Configuration.plain()

        configuration.imagePlacement = .leading
        configuration.titleAlignment = .trailing
        configuration.imagePadding = 50
        button.configuration = configuration
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.startVisionVC()
        }), for: .touchUpInside)
        button.tintColor = .gray
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
                    self.presentSnackbar(with: LocalizableString.snackBarCardAdded.value)
                    
                case .failure(let error):
                    UIAlertController.Builder()
                        .withTitle("Error")
                        .withMessage(error.localizedDescription)
                        .present(in: self)
                }
            })
            .store(in: &self.subscriptions)
    }
    
    private let enterCardInfoLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.addYourCardInformation.value
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let orLabel: UILabel = {
        
        let text = "Or"
        let line = "⎯⎯⎯⎯⎯⎯⎯⎯"

        // Configura los atributos del texto
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]

        let attributedText = NSMutableAttributedString(string: line, attributes: attributes)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: text, attributes: attributes))
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: line, attributes: attributes))

        let label = UILabel()
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: AddCreditCardCoordinatorDelegate?
    
    private let previewCreditCardView = PreviewCreditCardView()
    
    let creditCardNumberTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardNumberPlaceHolder.value,
            labelText: LocalizableString.cardNumberLabel.value.uppercased(),
            keyboardType: .numberPad
        )
    )
    
    let expiryDateTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.expirationDatePlaceHolder.value,
            labelText: LocalizableString.expirationDateLabel.value.uppercased()
        )
    )
    
    let nameOnCardTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardHolderNamePlaceHolder.value,
            labelText: LocalizableString.cardHolderNameLabel.value.uppercased()
        )
    )
    
    let cardNameTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardNamePlaceHolder.value,
            labelText: LocalizableString.cardNameLabel.value.uppercased()
        )
    )
    
    let cvvTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cvvPlaceHolder.value,
            labelText: LocalizableString.cvvLabel.value.uppercased(),
            keyboardType: .numberPad
        )
    )
    
    var viewModel: ViewModel
    
    //MARK: - Initialization
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructViewHerarchy()
        setUpConstraints()
        setUpSubscriptions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    //MARK: - View Construction
    
    private func constructViewHerarchy() {
        title = LocalizableString.addCreditCardTitle.value
        
        [
            creditCardNumberTextField.textField,
            nameOnCardTextField.textField,
            expiryDateTextField.textField,
            cardNameTextField.textField
        ].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        creditCardNumberTextField.delegate = self
        
        containerView.addAutoLayoutSubviews {
            enterCardInfoLabel
            scanCardButton
            orLabel
            ///preview
            previewCreditCardView
            
            ///textField
            creditCardNumberTextField
            nameOnCardTextField
            expiryDateTextField
            cardNameTextField
            cvvTextField

            ///buton
            addCreditCardButton
            
        }
        
        view.addAutoLayoutSubviews {
            scrollView
        }
        containerStack.addArrangedSubview(containerView)
        
        scrollView.addAutoLayoutSubviews {
            containerStack
        }
    }
    
    private func setUpConstraints() {
        view.activateConstraints {
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            
            containerStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            containerStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            containerStack.topAnchor.constraint(equalTo: scrollView.topAnchor)
            containerStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            containerStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
            enterCardInfoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
            enterCardInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            enterCardInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10)
            enterCardInfoLabel.heightAnchor.constraint(equalToConstant: 30)
            
            scanCardButton.topAnchor.constraint(equalTo: enterCardInfoLabel.bottomAnchor, constant: 10)
            scanCardButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            scanCardButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            scanCardButton.heightAnchor.constraint(equalToConstant: 46)
            
            orLabel.topAnchor.constraint(equalTo: scanCardButton.bottomAnchor, constant: 10)
            orLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            orLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            orLabel.heightAnchor.constraint(equalToConstant: 30)
            
            
            /// credit card preview
            previewCreditCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
            previewCreditCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
            previewCreditCardView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20)
            previewCreditCardView.heightAnchor.constraint(equalToConstant: 200)
            
            /// card number
            creditCardNumberTextField.topAnchor.constraint(equalTo: previewCreditCardView.bottomAnchor, constant: 50)
            creditCardNumberTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            creditCardNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)

            

            /// card holder name
            nameOnCardTextField.topAnchor.constraint(equalTo: creditCardNumberTextField.bottomAnchor, constant: 10)
            nameOnCardTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            nameOnCardTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            
            /// card alias
            
            cardNameTextField.topAnchor.constraint(equalTo: nameOnCardTextField.bottomAnchor, constant: 10)
            cardNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            cardNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            
            /// date
            expiryDateTextField.topAnchor.constraint(equalTo: cardNameTextField.bottomAnchor, constant: 10)
            expiryDateTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            expiryDateTextField.trailingAnchor.constraint(equalTo: cvvTextField.trailingAnchor, constant: 5)
            expiryDateTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4)
            
            
            /// cvv

            cvvTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            cvvTextField.topAnchor.constraint(equalTo: expiryDateTextField.topAnchor)
            cvvTextField.widthAnchor.constraint(equalTo: expiryDateTextField.widthAnchor, multiplier: 1.0)
            
            /// add CD button

            addCreditCardButton.topAnchor.constraint(greaterThanOrEqualTo: cvvTextField.bottomAnchor, constant: 40)
            addCreditCardButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            addCreditCardButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            addCreditCardButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            addCreditCardButton.heightAnchor.constraint(equalToConstant: 45)
            
        }
    }
    
    //MARK: Combine Subscriptions
    
    func setUpSubscriptions() {
        Publishers.CombineLatest4(
            viewModel.$creditCardName.eraseToAnyPublisher(),
            viewModel.$creditCardDate.eraseToAnyPublisher(),
            viewModel.$creditCardHolderName.eraseToAnyPublisher(),
            viewModel.$creditCardNumber.eraseToAnyPublisher()
        ).sink { [weak self] creditCardName, creditCardDate, creditCardHolderName, creditCardNumber in
            self?.previewCreditCardView.viewModel.holderName = creditCardHolderName
            self?.previewCreditCardView.viewModel.name = creditCardName
            self?.previewCreditCardView.viewModel.date = creditCardDate
            self?.previewCreditCardView.viewModel.number = creditCardNumber
        }
        .store(in: &subscriptions)
        
        viewModel.$creditCardDate
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: expiryDateTextField)
            .store(in: &subscriptions)
        
        viewModel.$creditCardNumber
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: creditCardNumberTextField)
            .store(in: &subscriptions)
        
        viewModel.$creditCardName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: cardNameTextField)
            .store(in: &subscriptions)
        
        viewModel.$creditCardHolderName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameOnCardTextField)
            .store(in: &subscriptions)
    }
    
    
    @objc
    func startVisionVC() {
        delegate?.startVisionKitCoordinator()
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case creditCardNumberTextField.textField:
            viewModel.creditCardNumber = textField.text
        case expiryDateTextField.textField:
            viewModel.creditCardDate = textField.text
        case cardNameTextField.textField:
            viewModel.creditCardName = textField.text
        case nameOnCardTextField.textField:
            viewModel.creditCardHolderName = textField.text
        default:
            return
        }
        
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
        
        var numberTextField: CFTextField {
            target.creditCardNumberTextField
        }
        
        var cardNameTextField: CFTextField {
            target.cardNameTextField
        }
        
        var expiryDateTextField: CFTextField {
            target.expiryDateTextField
        }
        
        var nameOnCardTextField: CFTextField {
            target.nameOnCardTextField
        }
        
        var cvvTextField: CFTextField {
            target.cvvTextField
        }
        
        
        var addButton: UIButton {
            target.addCreditCardButton
        }
    }
}

