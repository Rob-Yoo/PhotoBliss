//
//  TopicTrendDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct TopicTrendDTO: Decodable {
    let id: String
    let urls: ImageUrlDTO
    let likes: Int
}

struct ImageUrlDTO: Decodable {
    let raw: String
}
