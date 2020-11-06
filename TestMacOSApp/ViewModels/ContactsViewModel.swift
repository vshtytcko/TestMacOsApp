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
        guard row < contacts.count else {
            return nil
        }
        return contacts[row]
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
