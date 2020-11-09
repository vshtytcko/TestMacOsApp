//
//  ContactDetailsViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

protocol ContactDetailsViewModelProtocol {
    var delegate: ContactDetailsViewModelActionsProtocol? { get set }
    
    func viewDidLoad()
    func chatButtonPressed()
}

protocol ContactDetailsViewModelActionsProtocol: class {
    func updateDetailsView(stateModel: ContactDetailsViewStateModel)
}

class ContactDetailsViewModel: ContactDetailsViewModelProtocol {
    private let contact: Contact
    
    weak var delegate: ContactDetailsViewModelActionsProtocol?
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func viewDidLoad() {
        delegate?.updateDetailsView(stateModel: contactsDetailsStateModel())
    }
    
    func chatButtonPressed() {
        guard let service = NSSharingService(named: NSSharingService.Name.composeEmail), let email = contact.email else {
            return
        }
        service.recipients = [email]
        
        service.perform(withItems: [])
    }
    
    private func contactsDetailsStateModel() -> ContactDetailsViewStateModel {
        let nameLabelText = contact.nameInfo?.full ?? ""
        let pictureURL = contact.pictureInfo?.large ?? ""
        let dateOfBirthText = contact.dateOfBirthInfo?.date ?? ""
        let genderText = contact.gender?.rawValue ?? ""
        let contactsText = (contact.cell ?? "") + "\n" + (contact.phone ?? "")
        let locationText = (contact.locationInfo?.city ?? "") + ", " + (contact.locationInfo?.country ?? "")
        
        let stateModel = ContactDetailsViewStateModel(nameLabelText: nameLabelText, pictureURL: pictureURL, dateOfBirthText: dateOfBirthText, genderText: genderText, contactsText: contactsText, locationText: locationText)
        
        return stateModel
    }
}
