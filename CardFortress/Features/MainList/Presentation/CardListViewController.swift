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
import CFDomain

protocol CardListViewControllerDelegate: AnyObject {
    func signOut()
    func deleteCreditCard(id: UUID) async -> CardListViewController.CreditCardsOperationResult
    func editCreditCard(creditCard: DomainCreditCard)
}

final class CardListViewController: UIViewController {
    
    // MARK: private properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    private lazy var moreOptionsBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "ellipsis")
        button.tintColor = CFColors.purple.color
        button.target = self
        button.action = #selector(self.presentOptionsViewController(_:))
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
    }
    
    private func setupViews() {
        navigationItem.title = LocalizableString.mainViewTitle
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = moreOptionsBarButton
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
                
                debugPrint("got items")
                self?.applySnapshot(items: items, isLoading: false)
            }
            .store(in: &cancellables)
        
        
        viewModel.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] isLoading in
                
                debugPrint("loading ...")
                self?.applySnapshot(items: [], isLoading: isLoading)
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
    private func presentOptionsViewController(_ sender: UIBarButtonItem) {
        let viewController = OptionsViewController()
        viewController.delegate = self
        viewController.preferredContentSize = CGSize(width: 200,height: 300)
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.barButtonItem = sender
        viewController.presentationController?.delegate = self
        
        self.present(viewController, animated: true)
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
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath),
                  case .creditCard(let creditCard) = item else {
                completion(false)
                return
            }
            Task {
                var result: CreditCardsOperationResult?
                switch action {
                case .delete:
                    self?.viewModel.deleteCreditCard(creditCard.identifier)
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
        case loading
    }
    
    enum Item: Hashable {
        case creditCard(DomainCreditCard)
        case placeHolder(UUID)

        func hash(into hasher: inout Hasher) {
            switch self {
            case .creditCard(let card):
                hasher.combine("creditCard")
                hasher.combine(card.identifier)
            case .placeHolder(let id):
                hasher.combine(id)
            }
        }
    }
    
    let creditCardCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, DomainCreditCard> { cell, _, creditCard in
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
    
    let placeHolderCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Any> { cell, _, _ in
        cell.contentConfiguration = UIHostingConfiguration {
            CreditCardLoadingView()
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self else { return nil }
            switch item {
            case .creditCard(let creditCard):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.creditCardCellRegistration,
                    for: indexPath,
                    item: creditCard
                )
            case .placeHolder:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.placeHolderCellRegistration,
                    for: indexPath,
                    item: nil
                )
            }
        }
    }
    
    private func applySnapshot(items: [DomainCreditCard], isLoading: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        if isLoading {
            snapshot.appendSections([.loading])
            snapshot.appendItems([.placeHolder(UUID()), .placeHolder(UUID()), .placeHolder(UUID())], toSection: .loading)
        } else {
            snapshot.appendSections([.creditCard])
            snapshot.appendItems(items.map { .creditCard($0)}, toSection: .creditCard)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    enum CreditCardsOperationResult: Equatable {
        case success
        case failure
    }
}

extension CardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let creditCard = dataSource?.itemIdentifier(for: indexPath),
              case .creditCard(let creditCard) = creditCard else { return }
        delegate?.editCreditCard(creditCard: creditCard)
    }
}

// MARK: - TestHooks

#if DEBUG
extension CardListViewController {
    struct TestHooks {
        let target: CardListViewController
        var snapshot: NSDiffableDataSourceSnapshot<Section, Item>? {
            target.dataSource?.snapshot()
        }
        
        var dataSource: UICollectionViewDiffableDataSource<Section, Item>? {
            target.dataSource
        }
        
        var collectionView: UICollectionView {
            target.collectionView
        }
    
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif

extension CardListViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension CardListViewController: OptionsViewControllerDelegate {
    func logout() {
        self.delegate?.signOut()
    }
    
    func delete() {
//        self.viewModel.deleteAllCards()
    }
}

extension DomainCreditCard: Equatable {
    public static func == (lhs: DomainCreditCard, rhs: DomainCreditCard) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
