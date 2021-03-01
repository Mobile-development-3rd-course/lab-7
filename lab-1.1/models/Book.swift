//
//  Book.swift
//  lab-1.1
//
//  Created by Kirill on 24.02.2021.
//

import Foundation

struct BooksList: Codable {
    enum CodingKeys: String, CodingKey {
        case books
    }
    
    let books: [Book]
}

struct Book: Codable {
        let title: String
        let subtitle: String
        let isbn13: String
        let price: String
        let image: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case isbn13
        case price
        case image
    }
    
}
