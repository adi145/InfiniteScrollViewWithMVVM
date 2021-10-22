//
//  URLRequestExtension.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

extension URLRequest {

    init(service: EndpointProtocol) {
        let urlComponents = URLComponents(service: service)

        self.init(url: urlComponents.url!)

        httpMethod = service.method.rawValue
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        switch service.task {
        case let .requestParameters(params, _):
            if let parameters = params {
                httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
        case let .requestConsents(params, _):
            httpBody = params.data(using: .utf8)
        default:
            return
        }
    }
}
