//
//  URLSessionProtocol.swift
//  NetworkClient
//
//  Created by João Silveira on 23/03/2021.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        dataTask(with: request, completionHandler: completionHandler)
    }
}
