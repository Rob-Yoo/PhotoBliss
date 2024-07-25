//
//  PhotoDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let urls: ImageUrlDTO
    let likes: Int
    let createdAt: String
    let width: Int
    let height: Int
    let user: PhotographerDTO
    
    enum CodingKeys: String, CodingKey {
        case id, urls, likes, width, height, user
        case createdAt = "created_at"
    }
}

struct ImageUrlDTO: Decodable {
    let small: String
    let raw: String
}

struct PhotographerDTO: Decodable {
    let name: String
    let profileImage: ProfileImageDTO
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImageDTO: Decodable {
    let medium: String
}
