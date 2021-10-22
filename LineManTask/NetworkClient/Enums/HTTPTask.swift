//
//  HTTPTask.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

typealias ParametersRefactor = [[String: Any]]

enum HTTPTask {
    case requestPlain
    case requestParameters(_ body: ParametersRefactor?, urlQuery: ParametersRefactor? = nil)
    case requestConsents(_ body: String, urlQuery: ParametersRefactor? = nil)
}
