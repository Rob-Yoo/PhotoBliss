//
//  PhotoCellModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation
import UIKit

struct PhotoCellModel: Hashable, Identifiable {
    let id: String
    let smallPhotoImageUrl: String
    let starCount: Int
    let photographerImageUrl: String
    let photographerName: String
    let publishedDate: String
    let rawPhotoImageUrl: String
    let width: Int
    let height: Int
    var savedImageFilePath: String?
    var isLike: Bool
    
    static func ==(lhs: PhotoCellModel, rhs: PhotoCellModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func createPhotoCellModel(dto: PhotoDTO) -> Self {
        let convertedDateString = DateFormatManager.shared.convertDateFormat(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", outputDateFormat: "yyyy년 MM월 dd일", dateString: dto.createdAt) ?? "0000년 00월 00일"
        
        return PhotoCellModel(id: dto.id, smallPhotoImageUrl: dto.urls.small, starCount: dto.likes, photographerImageUrl: dto.user.profileImage.medium, photographerName: dto.user.name, publishedDate: convertedDateString, rawPhotoImageUrl: dto.urls.raw, width: dto.width, height: dto.height, isLike: false)
    }
    
    static func createPhotoCellModel(dto: PhotoLikeDTO, savedImageFilePath: String?) -> Self {
        return PhotoCellModel(id: dto.photoId, smallPhotoImageUrl: "", starCount: dto.starCount, photographerImageUrl: dto.photographerImageUrl, photographerName: dto.photographerName, publishedDate: dto.publishedDate, rawPhotoImageUrl: dto.rawPhotoImageUrl, width: dto.width, height: dto.height, savedImageFilePath: savedImageFilePath, isLike: true)
    }

}
