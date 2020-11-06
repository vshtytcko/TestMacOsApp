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
