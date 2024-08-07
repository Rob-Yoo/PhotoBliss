//
//  PhotoSearchResultDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

struct PhotoSearchResultDTO: Decodable {
    let totalPages: Int
    let results: [PhotoDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}
