//
//  SourceViewModel.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/3/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

protocol SourceViewModelProtocol: class {
    func viewDidLoad()
    func tableButtonPressed()
    func collectionButtonPressed()
}

class SourceViewModel: SourceViewModelProtocol {
    func viewDidLoad() {
        
    }
    
    func tableButtonPressed() {
//            DatabaseService.shared.entitiesFor(type: Contact.self, context: Constants.Database.mainObjectContext) { (contacts) in
//                for contact in contacts {
//                    print(contact.dateOfBirthInfo?.age, contact.dateOfBirthInfo?.date, contact.cell)
//                }
//            }
    }
    
    func collectionButtonPressed() {
//        DatabaseService.shared.saveMain()
    }
}
