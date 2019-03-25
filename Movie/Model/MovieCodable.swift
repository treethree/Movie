//
//  MovieCodable.swift
//  Movie
//
//  Created by SHILEI CUI on 3/23/19.
//  Copyright © 2019 scui5. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Welcome: Codable {
    let page, totalResults, totalPages: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct Result{
        let title: String
        let posterPath: String?
}
extension Result: Codable {
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let posterPath = try container.decode(String.self, forKey: .posterPath)   
        self.init(title: title , posterPath: posterPath)
    }
}

