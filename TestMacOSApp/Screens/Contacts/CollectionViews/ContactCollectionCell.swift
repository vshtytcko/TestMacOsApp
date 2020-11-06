//
//  ContactTableCell.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/5/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa


class ContactCollectionCell: NSCollectionViewItem {
    @IBOutlet private weak var pictureView: NSImageView!
    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var subtitleLabel: NSTextField!
    
    func setup(with stateModel: ContactTableCellStateModel) {
        pictureView.load(stateModel.imageURL)
        titleLabel.stringValue = stateModel.titleLabelText ?? ""
        subtitleLabel.stringValue = stateModel.subtitleLabelText ?? ""
    }
}
