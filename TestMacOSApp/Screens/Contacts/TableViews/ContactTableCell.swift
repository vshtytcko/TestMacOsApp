//
//  ContactTableCell.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/5/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa

struct ContactTableCellStateModel {
    var imageURL: String?
    var titleLabelText: String?
    var subtitleLabelText: String?
}

class ContactTableCell: NSTableCellView {
    @IBOutlet private weak var pictureView: NSImageView!
    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var subtitleLabel: NSTextField!
    
    func setup(with stateModel: ContactTableCellStateModel) {
        pictureView.load(stateModel.imageURL)
        titleLabel.stringValue = stateModel.titleLabelText ?? ""
        subtitleLabel.stringValue = stateModel.subtitleLabelText ?? ""
    }
}
