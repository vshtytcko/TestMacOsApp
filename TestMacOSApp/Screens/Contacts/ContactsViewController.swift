//
//  ContactsViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

class ContactsViewController: NSViewController {
    @IBOutlet private weak var tableView: NSTableView!
    
    private var viewModel: ContactsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        
        viewModel.viewDidLoad()
    }
}

private extension ContactsViewController {
    func setupDependancies() {
        viewModel = ContactsViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ContactsViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = NSView()
        let layer = CALayer()
        layer.backgroundColor = .black
        view.layer = layer
        return view
    }
}
