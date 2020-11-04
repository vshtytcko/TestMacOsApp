//
//  Constants.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class Constants {
    class Database {
        static let backgroundObjectContext = DatabaseService.shared.persistentContainer.backgroundContext
        static let mainObjectContext = DatabaseService.shared.persistentContainer.mainContext
    }
}
