//
//  Contact.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class Contact:  Codable {
    var gender: Gender?
    var nameInfo: NameInfo?
    var locationInfo: LocationInfo?
    var email: String?
    var loginInfo: LoginInfo?
    var dateOfBirthInfo: DateOfBirthInfo?
    var phone: String?
    var cell: String?
    var pictureInfo: PictureInfo?
    
    enum CodingKeys: String, CodingKey {
        case gender
        case nameInfo = "name"
        case locationInfo = "location"
        case email
        case loginInfo = "login"
        case dateOfBirthInfo = "dob"
        case phone
        case cell
        case pictureInfo = "picture"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        gender = try? container.decode(Gender.self, forKey: .gender)
        nameInfo = try? container.decode(NameInfo.self, forKey: .nameInfo)
        locationInfo = try? container.decode(LocationInfo.self, forKey: .locationInfo)
        email = try? container.decode(String.self, forKey: .email)
        loginInfo = try? container.decode(LoginInfo.self, forKey: .loginInfo)
        dateOfBirthInfo = try? container.decode(DateOfBirthInfo.self, forKey: .dateOfBirthInfo)
        phone = try? container.decode(String.self, forKey: .phone)
        cell = try? container.decode(String.self, forKey: .cell)
        pictureInfo = try? container.decode(PictureInfo.self, forKey: .pictureInfo)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gender, forKey: .gender)
        try container.encode(nameInfo, forKey: .nameInfo)
        try container.encode(locationInfo, forKey: .locationInfo)
        try container.encode(email, forKey: .email)
        try container.encode(loginInfo, forKey: .loginInfo)
        try container.encode(dateOfBirthInfo, forKey: .dateOfBirthInfo)
        try container.encode(phone, forKey: .phone)
        try container.encode(cell, forKey: .cell)
        try container.encode(pictureInfo, forKey: .pictureInfo)
    }
    
    enum Gender: String, Codable {
        case male, female
    }
    
    class NameInfo: Codable {
        let title: String?
        let first: String?
        let last: String?
        
        init(title: String?, first: String?, last: String?) {
            self.title = title
            self.first = first
            self.last = last
        }

        var full: String {
            var nameParts: [String] = []
            
            if let title = title {
                nameParts.append(title)
            }
            if let first = first {
                nameParts.append(first)
            }
            if let last = last {
                nameParts.append(last)
            }
            
            return nameParts.joined(separator: " ")
        }
    }
    
    class LocationInfo: Codable {
        struct Street: Codable {
            let number: Int
            let name: String
        }
        
        let street: Street
        let city: String
        let state: String
        let country: String
        let postcode: Int
        
        init(street: Street, city: String, state: String, country: String, postcode: Int) {
            self.street = street
            self.city = city
            self.state = state
            self.country = country
            self.postcode = postcode
        }
    }
    
    class LoginInfo: Codable {
        let username: String
        
        init(username: String) {
            self.username = username
        }
    }
    
    class DateOfBirthInfo: Codable {
        let date: String
        let age: Int
        
        init(date: String, age: Int) {
            self.date = date
            self.age = age
        }
    }
    
    class PictureInfo: Codable {
        let large: String
        let medium: String
        let thumbnail: String
        
        init(large: String, medium: String, thumbnail: String) {
            self.large = large
            self.medium = medium
            self.thumbnail = thumbnail
        }
    }
}

extension Array where Element: Contact {
    func filterWithSearchWord(_ word: String) -> [Contact] {
        guard !word.isEmpty else {
            return self
        }
        
        let filteredContacts = filter { (contact) -> Bool in
            guard let name = contact.nameInfo?.full.lowercased() else {
                return true
            }
            
            return name.contains(word)
        }
        
        return filteredContacts
    }
}
