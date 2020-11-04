//
//  ViewController.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Cocoa

class SplitViewController: NSViewController {

    private var viewModel: SplitViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SplitViewModel()
        viewModel.viewDidLoad()
    }


}

