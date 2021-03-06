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
    var mode: ContactsViewModel.Mode {get set}
    
    func viewDidLoad()
    func loadMoreContacts()
    func numberOfContacts() -> Int
    func contactCellStateModel(for row: Int) -> ContactTableCellStateModel?
    func loadMoreCellStateModel() -> LoadMoreTableCellStateModel
    func collectionViewDidSelectCell(at index: Int)
    func tableViewDidSelectCell(at index: Int)
    func searchDidUpdateWord(searchWord: String)
}

protocol ContactsViewModelActionsProtocol: AnyObject {
    func updateLoadingState(_ isLoading: Bool)
    func handleError(message: String)
    func reloadData()
    func updateView(with mode: ContactsViewModel.Mode)
    func showContactDetails(with contact: Contact)
}

class ContactsViewModel: ContactsViewModelProtocol {
    enum Mode {
        case table, collection
    }
    
    weak var delegate: ContactsViewModelActionsProtocol?
    
    var mode: Mode = .table {
        didSet {
            delegate?.updateView(with: self.mode)
        }
    }
    
    private var repository: ContactsRepositoryProtocol
    private var page: Int = 0
    private var shouldLoadMore: Bool = true
    private var searchWord: String = ""
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
        return contacts.filterWithSearchWord(searchWord).count
    }
    
    func contact(for row: Int) -> Contact? {
        guard row >= 0, row < contacts.filterWithSearchWord(searchWord).count else {
            return nil
        }
        return contacts.filterWithSearchWord(searchWord)[row]
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
    
    func collectionViewDidSelectCell(at index: Int) {
        guard let contact = contact(for: index) else {
            return
        }
        
        delegate?.showContactDetails(with: contact)
    }
    
    func tableViewDidSelectCell(at index: Int) {
        guard let contact = contact(for: index) else {
            return
        }
        
        delegate?.showContactDetails(with: contact)
    }
    
    func searchDidUpdateWord(searchWord: String) {
        self.searchWord = searchWord
        delegate?.reloadData()
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
            
            self.delegate?.reloadData()
        }
    }
}
