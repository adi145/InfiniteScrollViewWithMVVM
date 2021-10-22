//
//  DefaultURLSessionConfiguration.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

class DefaultURLSessionConfiguration {

    var configuration: URLSessionConfiguration

    init(configuration: URLSessionConfiguration = .default) {
        configuration.timeoutIntervalForRequest = 30
        self.configuration = configuration
    }
}
