//
//  PhotoModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct PhotoModel: Hashable, Identifiable {
    let id: String
    let imageURL: String
    let starCount: Int
    let isLike: Bool
    
    static func ==(lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
