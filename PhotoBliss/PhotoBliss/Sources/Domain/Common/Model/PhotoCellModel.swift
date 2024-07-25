//
//  PhotoCellModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct PhotoCellModel: Hashable, Identifiable {
    let id: String
    let imageURL: String
    let starCount: Int
    let isLike: Bool
    
    static func ==(lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func createPhotoCellModel(dto: PhotoDTO) -> Self {
        return PhotoCellModel(id: dto.id, imageURL: dto.urls.small, starCount: dto.likes, isLike: false)
    }
}
