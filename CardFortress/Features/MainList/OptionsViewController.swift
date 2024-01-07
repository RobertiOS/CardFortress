//
//  OptionsViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 12/31/23.
//

import UIKit

protocol OptionsViewControllerDelegate: AnyObject {
    func logout()
    func delete()
}

class OptionsViewController: UITableViewController {
    
    weak var delegate: OptionsViewControllerDelegate?

    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = dataSource
        dataSource.apply(snapshot)
    }
    
    enum Section {
        case main
    }
    
    enum Item {
        case logout
        case delete
        
        var cellText: String {
            switch self {
            case .logout:
                LocalizableString.signOut
            case .delete:
                LocalizableString.delete
            }
        }
        
        var cellIcon: UIImage {
            switch self {
            case .logout:
                UIImage(systemName: "rectangle.portrait.and.arrow.forward")!.withTintColor(.green)
            case .delete:
                UIImage(systemName: "minus.circle")!.withTintColor(.red)
            }
        }
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        .init(tableView: self.tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier)
            
            var contentConfiguration = cell?.defaultContentConfiguration()
            
            contentConfiguration?.text = itemIdentifier.cellText
            contentConfiguration?.image = itemIdentifier.cellIcon
            contentConfiguration?.imageProperties.tintColor = CFColors.purple.color
            
            cell?.contentConfiguration = contentConfiguration
            
            return cell
        }
    }()
    
    private let snapshot: NSDiffableDataSourceSnapshot<Section, Item> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([
            .delete,
            .logout
        ])
        return snapshot
    }()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .logout:
            delegate?.logout()
        case .delete:
            delegate?.delete()
        }
    }

}
