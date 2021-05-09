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

struct Book: Codable, Equatable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    var image: String
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case isbn13
        case price
        case image
    }
    init(title: String, subtitle: String, price: String){
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.isbn13 = "noid"
        self.image = ""
    }
}

struct DetailedBook: Codable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let authors: String
    let publisher: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
}
