//
//  PhotosModel.swift
//  LineManTask
//
//  Created by Adinarayana Machavarapu on 15/10/21.
//

import Foundation

// MARK: - PhotosModel
struct PhotosModel: Codable {
    let currentPage, totalPages, totalItems: Int
    let photos: [Photo]

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
        case photos
    }
}
// MARK: - Photo
struct Photo: Codable {
    let name: String
    let photoDescription: String
    let imageURL: [String]
    let votesCount: Int
    enum CodingKeys: String, CodingKey {
        case name
        case photoDescription = "description"
        case imageURL = "image_url"
        case votesCount = "votes_count"
    }
}

struct PhotosDisplayViewModel {
    let name, photoDescription, imageUrl, votesCount: String
}
