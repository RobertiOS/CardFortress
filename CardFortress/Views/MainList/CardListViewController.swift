//
//  CardListViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import Combine

protocol CardListViewControllerProtocol: UIViewController {
    var delegate: CardListViewControllerDelegate? { get set }
    var viewModel: ListViewModelProtocol { get set }
}

protocol CardListViewControllerDelegate: AnyObject {
    func signOut()
}

final class CardListViewController: UIViewController, CardListViewControllerProtocol {
    
    weak var delegate: CardListViewControllerDelegate?
    
    var viewModel: ListViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, CreditCard>!
    
    private lazy var deleteAllCardsBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "trash.fill")
        button.tintColor = .red
        button.target = self
        button.action = #selector(self.deleteAllCreditCards)
        return button
    }()
    
    private lazy var signOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        button.tintColor = .red
        button.target = self
        button.action = #selector(self.signOut)
        return button
    }()
    
    init(viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configureDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCreditCards()
    }
    
    private func setupViews() {
        navigationItem.title = LocalizableString.mainViewTitle.value
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [deleteAllCardsBarButton]
        navigationItem.leftBarButtonItem = signOutButton
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (view.bounds.width - 30), height: 250)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CreditCard>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCollectionViewCell
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [CreditCard]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CreditCard>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bindViewModel() {
        viewModel.fetchCreditCards()
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presentAlert(with: error)
                }
            }, receiveValue: { [weak self] items in
                self?.applySnapshot(items: items)
            })
            .store(in: &cancellables)
    }

    //MARK: Actions
    
    @objc
    private func presentAddCreditCardAlertController() {
        let alertController = UIAlertController(title: "Add Credit Card", message: nil, preferredStyle: .alert)
        let textFieldData = [("Card Number", UIKeyboardType.numberPad), ("CVV", UIKeyboardType.numberPad), ("Expiration Date (MM/YY)", UIKeyboardType.numbersAndPunctuation), ("Card Name (optional)", nil), ("Cardholder Name (optional)", nil)]

        for (placeholder, keyboardType) in textFieldData {
            alertController.addTextField {
                $0.placeholder = placeholder
                $0.keyboardType = keyboardType ?? .default
            }
        }
        
        

        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self,
                  let fields = alertController.textFields,
                  let number = fields[0].text, !number.isEmpty,
                  let cvv = fields[1].text, !cvv.isEmpty,
                  let date = fields[2].text, !date.isEmpty else {
                return
            }
            let card = CreditCard(identifier: UUID(), number: Int(number) ?? 0, cvv: Int(cvv) ?? 0, date: date, cardName: fields[3].text ?? "", cardHolderName: fields[4].text ?? "")
            self.viewModel.addCreditCard(card)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true)
    }

    @objc
    private func deleteAllCreditCards() {
        
        let alertController = UIAlertController(title: "Delete all credit cards", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.deleteAllCards()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    @objc
    private func signOut() {
        
        let alertController = UIAlertController(title: "Sign Out", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardListViewController {
    struct TestHooks {
        let target: CardListViewController
        var snapshot: NSDiffableDataSourceSnapshot<Int, CreditCard> {
            target.dataSource.snapshot()
        }

        var viewControllerTitle: String? {
            target.title
        }
        
        func presentAddCreditCardAlertController() {
            target.presentAddCreditCardAlertController()
        }
        
        func deleteAllCreditCards() {
            target.deleteAllCreditCards()
        }
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif
