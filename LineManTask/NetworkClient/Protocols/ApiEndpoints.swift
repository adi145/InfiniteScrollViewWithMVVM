//
//  UserEndPoints.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation
// MARK: -
let baseUrl = "https://api.500px.com/v1"

enum ApiEndpoints: EndpointProtocol {
    case photos(pages:[[String:Any]])
  
    var defaultHeaders: HTTPHeaders {
        var httpHeaders : [String:String] = [:]
        httpHeaders = ["Content-Type": "application/json"]
        return httpHeaders
    }
    
    var baseURL: URL {
        return URL(string:baseUrl)!
    }

    var path: String {
        switch self {
        case .photos(_):
            return "/photos"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .photos(_):
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .photos(pages: let pages):
            return .requestParameters(nil, urlQuery: pages)
        }
    }

    var headers: HTTPHeaders? {
        return defaultHeaders
    }
}
