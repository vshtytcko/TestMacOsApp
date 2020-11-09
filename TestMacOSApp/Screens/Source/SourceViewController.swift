//
//  SourceViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

protocol SourceViewSplitProtocol: class {
    func tableButtonPressed()
    func collectionButtonPressed()
}

class SourceViewController: NSViewController {
    @IBOutlet private weak var tableButton: NSButton!
    @IBOutlet private weak var collectionButton: NSButton!
    
    weak var delegate: SourceViewSplitProtocol?
    private var viewModel: SourceViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependancies()
        
        viewModel.viewDidLoad()
    }
    
    @IBAction private func tableButtonPressed(_ sender: Any) {
        delegate?.tableButtonPressed()
    }
    
    @IBAction private func collectionButtonPressed(_ sender: Any) {
        delegate?.collectionButtonPressed()
    }
}

private extension SourceViewController {
    func setupDependancies() {
        viewModel = SourceViewModel()
    }
}

