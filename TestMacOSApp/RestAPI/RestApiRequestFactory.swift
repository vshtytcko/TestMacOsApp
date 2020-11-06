//
//  RestApiRequestFactory.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Alamofire

public enum RestApiRequestFactory: URLRequestConvertible {
    case getContacts(page: Int, count: Int)

    private  var baseURL: String {
        return "https://randomuser.me/"
    }
    
    private var path: String {
        switch self {
        case .getContacts:
            return "api/"
        }
    }
    
    private var method: Alamofire.HTTPMethod {
        switch self {
        case .getContacts:
            return .get
        }
    }
    
    private var parametersEncoding: ParameterEncoding {
        switch self {
        case .getContacts:
            return Alamofire.JSONEncoding.default
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        switch self {
        case .getContacts(let page, let count):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "results", value: "\(count)")
            ]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let urlComponent = NSURLComponents(string: baseURL + path)
        urlComponent?.queryItems = queryComponents
        
        guard let url = urlComponent?.url else {
            throw NSError()
        }
        
        let urlRequest = try URLRequest(url: url, method: method)
        
        return try parametersEncoding.encode(urlRequest, with: nil)
    }
}
