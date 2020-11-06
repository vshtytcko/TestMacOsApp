//
//  NSImageView+Ext.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/5/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Cocoa
extension NSImageView {
    func load(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = NSImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
