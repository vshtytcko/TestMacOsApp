//
//  ContactsViewModel.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

protocol ContactsViewModelProtocol {
    var delegate: ContactsViewModelActionsProtocol? {get set}
    
    func viewDidLoad()
    func loadMoreContacts()
    func numberOfContacts() -> Int
    func contact(for row: Int) -> Contact?
    func contactCellStateModel(for row: Int) -> ContactTableCellStateModel?
    func loadMoreCellStateModel() -> LoadMoreTableCellStateModel
}

protocol ContactsViewModelActionsProtocol: AnyObject {
    func updateLoadingState(_ isLoading: Bool)
    func handleError(message: String)
    func reloadTableView()
}

class ContactsViewModel: ContactsViewModelProtocol {
    weak var delegate: ContactsViewModelActionsProtocol?
    
    private var repository: ContactsRepositoryProtocol
    private var page: Int = 0
    private var shouldLoadMore: Bool = true
    private var contacts: [Contact] = []
    
    init() {
        repository = ContactsRepository()
    }
    
    func viewDidLoad() {
        refreshContacts()
    }
    
    func loadMoreContacts() {
        loadContacts()
    }
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
    
    func contact(for row: Int) -> Contact? {
        guard row >= 0, row < contacts.count else {
            return nil
        }
        return contacts[row]
    }
    
    func contactCellStateModel(for row: Int) -> ContactTableCellStateModel? {
        guard let contact = contact(for: row) else {
                return nil
        }
        
        let stateModel = ContactTableCellStateModel(imageURL: contact.pictureInfo?.thumbnail, titleLabelText: contact.nameInfo?.full, subtitleLabelText: contact.email)
        return stateModel
    }
    
    func loadMoreCellStateModel() -> LoadMoreTableCellStateModel {
        let stateModel = LoadMoreTableCellStateModel(loadMoreAction: {
            self.loadMoreContacts()
        })
        
        return stateModel
    }
}

private extension ContactsViewModel {
    func refreshContacts() {
        shouldLoadMore = true
        page = 0
        contacts = []
        
        loadContacts()
    }
    
    func loadContacts() {
        guard shouldLoadMore else {
            return
        }
        
        delegate?.updateLoadingState(true)
        repository.refreshContacts(page: page, count: Constants.Rest.countOfItemsInBatch) { (contacts, errorText) in
            self.delegate?.updateLoadingState(false)
            guard let contacts = contacts, !contacts.isEmpty else {
                if let errorText = errorText {
                    self.delegate?.handleError(message: errorText)
                } else {
                    self.shouldLoadMore = false
                }
                
                return
            }
            
            self.page += 1
            self.contacts.append(contentsOf: contacts)
            
            self.delegate?.reloadTableView()
        }
    }
}
