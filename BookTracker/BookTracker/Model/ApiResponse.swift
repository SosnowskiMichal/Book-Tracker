//
//  ApiResponse.swift
//  BookManagementApp
//
//  Created by stud on 21/01/2025.
//

import Foundation

struct ApiResponse: Decodable {
    var docs: [ApiBook]
}

struct ApiBook: Decodable, Identifiable {
    var key: String
    var title: String
    var author_name: [String]
    var first_publish_year: Int
    var cover_i: Int?
    
    var id: String { key }
}

struct ApiWorkString: Decodable {
    var description: String?
}

struct ApiWorkObject: Decodable {
    var description: DescriptionObject?
}

struct DescriptionObject: Decodable {
    var value: String?
}
