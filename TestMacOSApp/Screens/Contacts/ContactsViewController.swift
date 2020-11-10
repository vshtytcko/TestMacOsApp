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
    @IBOutlet private weak var collectionViewContainer: NSView!
    @IBOutlet private weak var tableViewContainer: NSView!
    @IBOutlet weak var searchField: NSSearchField!
    
    weak var delegate: ContactsViewControllerSplitProtocol?
    var viewModel: ContactsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        setupView()
        
        viewModel.viewDidLoad()
    }
    
    @IBAction private func tableViewDidSelect(_ sender: Any) {
        viewModel.tableViewDidSelectCell(at: tableView.selectedRow)
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
    func showContactDetails(with contact: Contact) {
        delegate?.showDetails(for: contact)
    }
    
    func reloadData() {
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func updateView(with mode: ContactsViewModel.Mode) {
        switch mode {
        case .table:
            tableViewContainer.isHidden = false
            collectionViewContainer.isHidden = true
        case .collection:
            tableViewContainer.isHidden = true
            collectionViewContainer.isHidden = false
        }
    }
    
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
        guard let selectedIndex = indexPaths.first?.item else {
            return
        }
        
        viewModel.collectionViewDidSelectCell(at: selectedIndex)
    }
}

extension ContactsViewController: NSSearchFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let word = (obj.object as? NSSearchField)?.stringValue else {
            return
        }
        
        viewModel.searchDidUpdateWord(searchWord: word)
    }
}
