//
//  ContactsDetailsViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

struct ContactDetailsViewStateModel {
    let nameLabelText: String
    let pictureURL: String
    let dateOfBirthText: String
    let genderText: String
    let contactsText: String
    let locationText: String
}

class ContactDetailsViewController: NSViewController {
    @IBOutlet private weak var pictureView: NSImageView!
    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var genderLabel: NSTextField!
    @IBOutlet private weak var locationLabel: NSTextField!
    @IBOutlet private weak var contactsLabel: NSTextField!
    @IBOutlet private weak var dateOfBirthLabel: NSTextField!
    
    var viewModel: ContactDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    @IBAction private func chatButtonPressed(_ sender: Any) {
        viewModel.chatButtonPressed()
    }
}


extension ContactDetailsViewController: ContactDetailsViewModelActionsProtocol {
    func updateDetailsView(stateModel: ContactDetailsViewStateModel) {
        pictureView.load(stateModel.pictureURL)
        nameLabel.stringValue = stateModel.nameLabelText
        genderLabel.stringValue = stateModel.genderText
        locationLabel.stringValue = stateModel.locationText
        contactsLabel.stringValue = stateModel.contactsText
        dateOfBirthLabel.stringValue = stateModel.dateOfBirthText
    }
}
