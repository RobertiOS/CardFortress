//
//  CardListViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit
import SwiftUI
import Combine
import CFSharedUI

protocol CardListViewControllerProtocol: UIViewController {
    var delegate: CardListViewControllerDelegate? { get set }
    var viewModel: ListViewModelProtocol { get set }
}

protocol CardListViewControllerDelegate: AnyObject {
    func signOut()
    func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult
    func editCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult
}

final class CardListViewController: UIViewController, CardListViewControllerProtocol {
    
    // MARK: private properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CreditCard>!
    
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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: internal/ public properties
    
    weak var delegate: CardListViewControllerDelegate?
    var viewModel: ListViewModelProtocol
    
    // MARK: Initialization
    
    init(viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Controller Life Cicle
    
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
        
        constructSubviewHierarchy()
        constructSubviewLayoutConstraints()
    }
    
    private func constructSubviewHierarchy() {
        view.addAutoLayoutSubviews {
            collectionView
        }
    }
    
    private func constructSubviewLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
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
    
    enum Action: Equatable {
        case delete
        case edit
        
        var title: String {
            switch self {
            case .delete:
                return "Delete"
            case .edit:
                return "Edit"
            }
        }
        
        var style: UIContextualAction.Style {
            switch self {
            case .delete:
                return .destructive
            case .edit:
                return .normal
            }
        }
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

    // MARK: collection view layout

    private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

        /// delete credits cards action
        configuration.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let deleteAction = createContextualAction(for: .delete, indexPath: indexPath)
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        /// edit credits cards action
        configuration.leadingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let editAction = createContextualAction(for: .edit, indexPath: indexPath)
            return UISwipeActionsConfiguration(actions: [editAction])
        }

        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )

        return section
    }
    
    private func createContextualAction(for action: Action, indexPath: IndexPath) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: action.style, title: action.title) { [unowned self] _, _, completion in
            guard let creditCard = dataSource.itemIdentifier(for: indexPath) else {
                completion(false)
                return
            }
            Task {
                var result: CreditCardsOperationResult?
                switch action {
                case .delete:
                    result = await delegate?.deleteCreditCard(id: creditCard.identifier)
                case .edit:
                    result = await delegate?.editCreditCard(id: creditCard.identifier)
                }
                completion(result == .success)
            }
        }
        return contextualAction
    }

    // MARK: collection view data source
    
    enum Section {
        case creditCard
        case other
    }
    
    let creditCardCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, CreditCard> { cell, _, creditCard in
        cell.contentConfiguration = UIHostingConfiguration {
            let viewModel: CreditCardViewModel = .init(
                cardHolderName: creditCard.cardHolderName,
                cardNumber: creditCard.number,
                date: creditCard.date,
                bankName: creditCard.cardName,
                cvv: creditCard.cvv
            )
            CreditCardView(viewModel: viewModel)
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CreditCard>(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self else { return nil }
            
            return collectionView.dequeueConfiguredReusableCell(
                using: self.creditCardCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func applySnapshot(items: [CreditCard]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CreditCard>()
        snapshot.appendSections([.creditCard])
        snapshot.appendItems(items, toSection: .creditCard)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    enum CreditCardsOperationResult: Equatable {
        case success
        case failure
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardListViewController {
    struct TestHooks {
        let target: CardListViewController
        var snapshot: NSDiffableDataSourceSnapshot<Section, CreditCard> {
            target.dataSource.snapshot()
        }
        
        var dataSource: UICollectionViewDiffableDataSource<Section, CreditCard> {
            target.dataSource
        }

        var viewControllerTitle: String? {
            target.title
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
