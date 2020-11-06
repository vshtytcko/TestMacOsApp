//
//  ContactsRepository.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Alamofire

protocol ContactsRepositoryProtocol {
    func refreshContacts(page: Int, count: Int, completion: @escaping (([Contact]?, String?) -> Void))
}

class ContactsRepository: ContactsRepositoryProtocol {
    func refreshContacts(page: Int, count: Int, completion: @escaping (([Contact]?, String?) -> Void)) {
        guard let request = RestApiRequestFactory.getContacts(page: page, count: count).urlRequest else {return}
        AF.request(request).validate().responseDecodable(of: ContactsResponse.self) { (response) in
            completion(response.value?.results, response.error?.localizedDescription)
        }
    }
}
