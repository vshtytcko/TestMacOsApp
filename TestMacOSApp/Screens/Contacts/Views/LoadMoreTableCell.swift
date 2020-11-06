//
//  LoadMoreTableCell.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/6/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

struct LoadMoreTableCellStateModel {
    var loadMoreAction: (() -> ())?
}

class LoadMoreTableCell: NSTableCellView {
    private var loadMoreAction: (() -> ())?
    
    func setup(with stateModel: LoadMoreTableCellStateModel) {
        loadMoreAction = stateModel.loadMoreAction
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func loadMoreButtonPressed(_ sender: Any) {
        loadMoreAction?()
    }
}
