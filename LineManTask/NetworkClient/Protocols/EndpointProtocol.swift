//
//  EndpointProtocol.swift
//  NetworkClient
//
// Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol EndpointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
