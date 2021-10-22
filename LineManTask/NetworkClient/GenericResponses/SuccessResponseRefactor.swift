//
//  SuccessResponse_Refactor.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

struct SuccessResponse: Codable {
    var success: Bool = false

    private enum CodingKeys: String, CodingKey {
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        } catch DecodingError.typeMismatch {
            if let string = try container.decodeIfPresent(String.self, forKey: .success) {
                self.success = string == "true"
            }
        }
    }
}
