//
//  AddCreditCardViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import UIKit
import Combine
import SwiftUI
import CFSharedUI

final class AddCreditCardViewController: UIViewController {

    //MARK: - subviews
    
    private lazy var addCreditCardButton: UIButton = {
        let button = UIButton()
        button.setTitle(
            (viewModel.action == .addCreditCard ? LocalizableString.addCreditCardButtonTitle : LocalizableString.editCreditCardButtonTitle),
            for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.addAction(addAction, for: .touchUpInside)
        button.backgroundColor = CFColors.purple.color
        return button
    }()
    
    private lazy var scanCardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle(LocalizableString.scanYourCard, for: .normal)
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let failure):
                    UIAlertController.Builder()
                        .withTitle("Error")
                        .withMessage(failure.localizedDescription)
                        .present(in: self)
                }
            }, receiveValue: { [weak self] result in
                guard let self else { return }
                switch viewModel.action {
                case .addCreditCard:
                    self.presentSnackbar(with: LocalizableString.snackBarCardAdded)
                case .editCreditCard:
                    self.presentSnackbar(with: LocalizableString.snackBarCardSaved)
                }
            })
            .store(in: &self.subscriptions)
    }
    
    private let enterCardInfoLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.addYourCardInformation
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
    
    private let scrollView = UIScrollView()
    
    
    private let stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        return stackView
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: AddCreditCardCoordinatorDelegate?
    
    private var previewCreditCardView = CreditCardView(viewModel: .init())
    private lazy var hostingView = UIHostingControllerWrapper(rootView: previewCreditCardView).view ?? UIView()
    
    let creditCardNumberTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardNumberPlaceHolder,
            labelText: LocalizableString.cardNumberLabel.uppercased(),
            keyboardType: .numberPad
        )
    )
    
    let expiryDateTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.expirationDatePlaceHolder,
            labelText: LocalizableString.expirationDateLabel.uppercased()
        )
    )
    
    let nameOnCardTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardHolderNamePlaceHolder,
            labelText: LocalizableString.cardHolderNameLabel.uppercased()
        )
    )
    
    let cardNameTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cardNamePlaceHolder,
            labelText: LocalizableString.cardNameLabel.uppercased()
        )
    )
    
    let cvvTextField = CFTextField(
        viewModel: .init(
            placeHolder: LocalizableString.cvvPlaceHolder,
            labelText: LocalizableString.cvvLabel.uppercased(),
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.viewControllerWillDissapear()
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
        title = viewModel.action == .addCreditCard ? LocalizableString.addCreditCardTitle :
        LocalizableString.editCreditCardTitle
        
        [
            creditCardNumberTextField.textField,
            nameOnCardTextField.textField,
            expiryDateTextField.textField,
            cardNameTextField.textField
        ].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            $0.delegate = self
        }
        
        
        stackViewContainer.addArrangedSubviews {
            enterCardInfoLabel
            scanCardButton
            orLabel
            ///preview
            hostingView
            
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
        
        scrollView.addAutoLayoutSubviews {
            stackViewContainer
        }
        
    }
    
    private func setUpConstraints() {
        view.activateConstraints {
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            
            stackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            stackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            stackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor)
            stackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            stackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        }
    }
    
    //MARK: Combine Subscriptions
    
    func setUpSubscriptions() {
        Publishers.CombineLatest4(
            viewModel.$creditCardName.eraseToAnyPublisher(),
            viewModel.$creditCardDate.eraseToAnyPublisher(),
            viewModel.$creditCardHolderName.eraseToAnyPublisher(),
            viewModel.$creditCardNumber.eraseToAnyPublisher()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] creditCardName, creditCardDate, creditCardHolderName, creditCardNumber in
            self?.previewCreditCardView.viewModel.bankName = creditCardName ?? ""
            self?.previewCreditCardView.viewModel.cardNumber = creditCardNumber ?? ""
            self?.previewCreditCardView.viewModel.date = creditCardDate ?? ""
            self?.previewCreditCardView.viewModel.cardHolderName = creditCardHolderName ?? ""
        }
        .store(in: &subscriptions)
        
        viewModel.$creditCardDate
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: expiryDateTextField)
            .store(in: &subscriptions)
        
        viewModel.$creditCardNumber
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .map { String($0)}
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
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        switch textField {
        case creditCardNumberTextField.textField:
            textField.text = currentText.grouping(every: 4, with: " ")
            return false
        case expiryDateTextField.textField:
            textField.text = currentText.grouping(every: 2, with: "/")
            return false
        default:
            return true
        }
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
        
        var scrollView: UIScrollView {
            target.scrollView
        }
        
        var addButton: UIButton {
            target.addCreditCardButton
        }
    }
}

