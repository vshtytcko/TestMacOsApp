//
//  ViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Cocoa

class SplitViewController: NSViewController, NSSplitViewDelegate {
    @IBOutlet weak var splitView: NSSplitView!
    
    private var sourceViewController: SourceViewController!
    private var contactsViewController: ContactsViewController!
    private var contactDetailsViewController: ContactDetailsViewController?
    
    private var viewModel: SplitViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SplitViewModel()
        viewModel.viewDidLoad()
        
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let sourceViewController = segue.destinationController as? SourceViewController {
            self.sourceViewController = sourceViewController
        }
        if let contactsViewController = segue.destinationController as? ContactsViewController {
            self.contactsViewController = contactsViewController
            self.contactsViewController.delegate = self
        }
    }
}

extension SplitViewController: ContactsViewControllerSplitProtocol {
    func showDetails(for contact: Contact) {
        if splitView.subviews.count > 1 {
            splitView.subviews[1].removeFromSuperview()
        }
        let contactDetailsVC = StoryboardScene.ContactDetails.initialScene.instantiate()
        contactDetailsVC.viewModel = ContactDetailsViewModel(contact: contact)
        contactDetailsViewController = contactDetailsVC
        
        splitView.addArrangedSubview(contactDetailsVC.view)
    }
}
