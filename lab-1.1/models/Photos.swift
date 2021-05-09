//
//  Photos.swift
//  lab-1.1
//
//  Created by Kirill on 09.05.2021.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let views: Int
    let downloads: Int
    let favorites: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}

struct Photos: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Photo]
}
