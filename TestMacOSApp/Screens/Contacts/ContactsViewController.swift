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

class ContactsViewController: NSViewController {
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var activityIndicator: CircularProgress!
    
    private var viewModel: ContactsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        setupView()
        
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        viewModel.viewDidLoad()
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
        print("error", message)
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
            
            let stateModel = LoadMoreTableCellStateModel(loadMoreAction: {
                self.viewModel.loadMoreContacts()
            })
            cell.setup(with: stateModel)
            return cell
        default:
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(describing: ContactTableCell.self)), owner: self) as? ContactTableCell,
                let contact = viewModel.contact(for: row) else {
                    return nil
            }
            
            let stateModel = ContactTableCellStateModel(imageURL: contact.pictureInfo?.thumbnail, titleLabelText: contact.nameInfo?.full, subtitleLabelText: contact.email)
            cell.setup(with: stateModel)
            return cell
        }
    }
}
