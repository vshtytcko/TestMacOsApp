//
//  Contact.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject, Codable {
    @NSManaged public var gender: String
    @NSManaged public var nameInfo: NameInfo?
    @NSManaged public var locationInfo: LocationInfo?
    @NSManaged public var email: String?
    @NSManaged public var loginInfo: LoginInfo?
    @NSManaged public var dateOfBirthInfo: DateOfBirthInfo?
    @NSManaged public var phone: String?
    @NSManaged public var cell: String?
    @NSManaged public var pictureInfo: PictureInfo?
    
    @objc(NameInfo)
    public class NameInfo: NSObject, NSCoding, Codable {
        enum Key: String {
            case title, first, last
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(title, forKey: Key.title.rawValue)
            coder.encode(first, forKey: Key.first.rawValue)
            coder.encode(last, forKey: Key.last.rawValue)
        }
        
        public required convenience init?(coder: NSCoder) {
            let title = coder.decodeObject(forKey: Key.title.rawValue) as? String
            let first = coder.decodeObject(forKey: Key.first.rawValue) as? String
            let last = coder.decodeObject(forKey: Key.last.rawValue) as? String
            
            self.init(title: title, first: first, last: last)
        }
        
        let title: String?
        let first: String?
        let last: String?
        
        init(title: String?, first: String?, last: String?) {
            self.title = title
            self.first = first
            self.last = last
        }
    }
    
    @objc(LocationInfo)
    public class LocationInfo: NSObject, NSCoding, Codable {
        enum Key: String {
            case street, city, state, country, postcode
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(street, forKey: Key.street.rawValue)
            coder.encode(city, forKey: Key.city.rawValue)
            coder.encode(state, forKey: Key.state.rawValue)
            coder.encode(country, forKey: Key.country.rawValue)
            coder.encode(postcode, forKey: Key.postcode.rawValue)
        }
        
        public required convenience init?(coder: NSCoder) {
            let street = coder.decodeObject(forKey: Key.street.rawValue) as? Street
            let city = coder.decodeObject(forKey: Key.city.rawValue) as? String
            let state = coder.decodeObject(forKey: Key.state.rawValue) as? String
            let country = coder.decodeObject(forKey: Key.country.rawValue) as? String
            let postcode = coder.decodeObject(forKey: Key.postcode.rawValue) as? Int
            
            self.init(street: street, city: city, state: state, country: country, postcode: postcode)
        }
        
        
        struct Street: Codable {
            let number: Int
            let name: String
        }
        
        let street: Street?
        let city: String?
        let state: String?
        let country: String?
        let postcode: Int?
        
        init(street: Street?, city: String?, state: String?, country: String?, postcode: Int?) {
            self.street = street
            self.city = city
            self.state = state
            self.country = country
            self.postcode = postcode
        }
    }
    
    @objc(LoginInfo)
    public class LoginInfo: NSObject, NSCoding, Codable {
        enum Key: String {
            case username
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(username, forKey: Key.username.rawValue)
        }
        
        public required convenience init?(coder: NSCoder) {
            let username = coder.decodeObject(forKey: Key.username.rawValue) as? String
            
            self.init(username: username)
        }
        
        let username: String?
        
        init(username: String?) {
            self.username = username
        }
    }
    
    @objc(DateOfBirthInfo)
    public class DateOfBirthInfo: NSObject, NSCoding, Codable {
        enum Key: String {
            case date, age
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(age, forKey: Key.age.rawValue)
            coder.encode(date, forKey: Key.date.rawValue)
        }
        
        public required convenience init?(coder: NSCoder) {
            let age = (coder.decodeObject(forKey: Key.age.rawValue) as? Int)
            let date = (coder.decodeObject(forKey: Key.date.rawValue) as? Date)
            
            self.init(date: date, age: age)
        }
        
        
        let date: Date?
        let age: Int?
        
        init(date: Date?, age: Int?) {
            self.date = date
            self.age = age
        }
    }
    
    @objc (PictureInfo)
    public class PictureInfo: NSObject, NSCoding, Codable {
        enum Key: String {
            case large, medium, thumbnail
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(large, forKey: Key.large.rawValue)
            coder.encode(medium, forKey: Key.medium.rawValue)
            coder.encode(thumbnail, forKey: Key.thumbnail.rawValue)
        }
        
        public required convenience init?(coder: NSCoder) {
            let large = coder.decodeObject(forKey: Key.large.rawValue) as? String
            let medium = coder.decodeObject(forKey: Key.medium.rawValue) as? String
            let thumbnail = coder.decodeObject(forKey: Key.thumbnail.rawValue) as? String
            
            self.init(large: large, medium: medium, thumbnail: thumbnail)
        }
        
        let large: String?
        let medium: String?
        let thumbnail: String?
        
        init(large: String?, medium: String?, thumbnail: String?) {
            self.large = large
            self.medium = medium
            self.thumbnail = thumbnail
        }
    }
    
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
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        let container = try decoder.container(keyedBy: CodingKeys.self)

        gender = try container.decode(String.self, forKey: .gender)
        nameInfo = try container.decode(NameInfo.self, forKey: .nameInfo)
        locationInfo = try container.decode(LocationInfo.self, forKey: .locationInfo)
        email = try container.decode(String.self, forKey: .email)
        loginInfo = try container.decode(LoginInfo.self, forKey: .loginInfo)
        dateOfBirthInfo = try container.decode(DateOfBirthInfo.self, forKey: .dateOfBirthInfo)
        phone = try container.decode(String.self, forKey: .phone)
        cell = try container.decode(String.self, forKey: .cell)
        pictureInfo = try container.decode(PictureInfo.self, forKey: .pictureInfo)
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
}

extension Contact {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
}

