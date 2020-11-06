//
//  ContactsViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa
import CircularProgressMac

protocol ContactsViewControllerSplitProtocol: class {
    func showDetails(for contact: Contact)
}

class ContactsViewController: NSViewController {
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var activityIndicator: CircularProgress!
    @IBOutlet private weak var collectionView: NSCollectionView!
    
    weak var delegate: ContactsViewControllerSplitProtocol?
    private var viewModel: ContactsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        setupView()
        
        viewModel.viewDidLoad()
    }
    
    @IBAction private func tableViewDidSelect(_ sender: Any) {
        guard let contact = viewModel.contact(for: tableView.selectedRow) else {
            return
        }
        
        delegate?.showDetails(for: contact)
    }
}

private extension ContactsViewController {
    func setupDependancies() {
        viewModel = ContactsViewModel()
        viewModel.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupView() {
        activityIndicator.isIndeterminate = true
    }
}

extension ContactsViewController: ContactsViewModelActionsProtocol {
    func updateLoadingState(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
    }
    
    func handleError(message: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = message
        alert.addButton(withTitle: L10n.ok)
        if let window = view.window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        }
    }
    
    func reloadTableView() {
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension ContactsViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.numberOfContacts() + 1
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch row {
        case viewModel.numberOfContacts():
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(describing: LoadMoreTableCell.self)), owner: self) as? LoadMoreTableCell else {
                    return nil
            }
            
            let stateModel = viewModel.loadMoreCellStateModel()
            cell.setup(with: stateModel)
            return cell
        default:
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(describing: ContactTableCell.self)), owner: self) as? ContactTableCell, let stateModel = viewModel.contactCellStateModel(for: row) else {
                return nil
            }
                
            cell.setup(with: stateModel)
            return cell
        }
    }
}


extension ContactsViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfContacts() + 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        switch indexPath.item {
        case viewModel.numberOfContacts():
            guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:  String(describing: LoadMoreCollectionCell.self)), for: indexPath) as? LoadMoreCollectionCell else {
                return NSCollectionViewItem()
            }
            
            let stateModel = viewModel.loadMoreCellStateModel()
            item.setup(with: stateModel)
            return item
        default:
            guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:  String(describing: ContactCollectionCell.self)), for: indexPath) as? ContactCollectionCell, let stateModel = viewModel.contactCellStateModel(for: indexPath.item) else {
                return NSCollectionViewItem()
            }
            
            item.setup(with: stateModel)
            return item
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        guard let selectedIndex = indexPaths.first?.item, let contact = viewModel.contact(for: selectedIndex) else {
            return
        }
        
        delegate?.showDetails(for: contact)
    }
}


