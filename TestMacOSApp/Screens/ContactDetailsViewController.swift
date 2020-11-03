//
//  ContactsDetailsViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

class ContactDetailsViewController: NSViewController {
    private var viewModel: ContactDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        
        viewModel.viewDidLoad()
    }
}

private extension ContactDetailsViewController {
    func setupDependancies() {
        viewModel = ContactDetailsViewModel()
    }
}
