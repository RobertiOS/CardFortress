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

protocol CardListViewControllerDelegate: AnyObject {
    func signOut()
    func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult
    func editCreditCard(creditCard: CreditCard)
}

final class CardListViewController: UIViewController {
    
    // MARK: private properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CreditCard>?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
    
    private func setupViews() {
        navigationItem.title = LocalizableString.mainViewTitle
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [deleteAllCardsBarButton]
        navigationItem.leftBarButtonItem = signOutButton
        collectionView.delegate = self
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
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presentAlert(with: error)
                }
            } receiveValue: { [weak self] items in
                self?.applySnapshot(items: items)
            }
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
        UIAlertController.Builder()
            .addActions([
                .init(title: LocalizableString.delete, style: .destructive, handler: { [weak self] _ in
                    self?.viewModel.deleteAllCards()
                }),
                .init(title: LocalizableString.cancel, style: .cancel, handler: nil)
            ])
            .withTitle(LocalizableString.deleteAllCreditCards)
            .present(in: self)
    }
    
    @objc
    private func signOut() {
        UIAlertController.Builder()
            .addActions([
                .init(title: LocalizableString.confirm, style: .destructive, handler: { [weak self] _ in
                    self?.delegate?.signOut()
                }),
                .init(title: LocalizableString.cancel, style: .cancel, handler: nil)
            ])
            .withTitle(LocalizableString.signOut)
            .present(in: self)
    }

    // MARK: collection view layout

    private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

        /// delete credits cards action
        configuration.trailingSwipeActionsConfigurationProvider = {  indexPath in
            if let deleteAction = self?.createContextualAction(for: .delete, indexPath: indexPath) {
                let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
                return swipeConfig
            } else {
                return nil
            }
        }

        /// edit credits cards action
        configuration.leadingSwipeActionsConfigurationProvider = {  indexPath in
            if let editAction = self?.createContextualAction(for: .edit, indexPath: indexPath) {
                let swipeConfig = UISwipeActionsConfiguration(actions: [editAction])
                return swipeConfig
            } else {
                return nil
            }
        }

        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )

        return section
    }
    
    private func createContextualAction(for action: Action, indexPath: IndexPath) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: action.style, title: action.title) { [weak self] _, _, completion in
            guard let creditCard = self?.dataSource?.itemIdentifier(for: indexPath) else {
                completion(false)
                return
            }
            Task {
                var result: CreditCardsOperationResult?
                switch action {
                case .delete:
                    result = await self?.delegate?.deleteCreditCard(id: creditCard.identifier)
                case .edit:
                    result = await self?.delegate?.deleteCreditCard(id: creditCard.identifier)
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
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    enum CreditCardsOperationResult: Equatable {
        case success
        case failure
    }
}

extension CardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let creditCard = dataSource?.itemIdentifier(for: indexPath) else { return }
        delegate?.editCreditCard(creditCard: creditCard)
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardListViewController {
    struct TestHooks {
        let target: CardListViewController
        var snapshot: NSDiffableDataSourceSnapshot<Section, CreditCard>? {
            target.dataSource?.snapshot()
        }
        
        var dataSource: UICollectionViewDiffableDataSource<Section, CreditCard>? {
            target.dataSource
        }
        
        var collectionView: UICollectionView {
            target.collectionView
        }
        
        func deleteAllCreditCards() {
            target.deleteAllCreditCards()
        }
        
        func signOut() {
            target.signOut()
        }

    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif
