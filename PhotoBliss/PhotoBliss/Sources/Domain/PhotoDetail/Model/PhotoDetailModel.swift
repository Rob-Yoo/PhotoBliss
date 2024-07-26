//
//  PhotoDetailModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

struct PhotoDetailModel: Identifiable {
    let id: String
    let photographerImageUrl: String
    let photographerName: String
    let publishedDate: String
    let photoImageUrl: String
    let width: Int
    let height: Int
    let viewCount: Int
    let downloadCount: Int
    let isLike: Bool
    
    static func createPhotoDetailModel(photo: PhotoCellModel, photoStatistic: PhotoStatisticDTO) -> Self {

        return PhotoDetailModel(id: photo.id, photographerImageUrl: photo.photographerImageUrl, photographerName: photo.photographerName, publishedDate: photo.publishedDate, photoImageUrl: photo.rawPhotoImageUrl, width: photo.width, height: photo.height, viewCount: photoStatistic.views.total, downloadCount: photoStatistic.downloads.total, isLike: photo.isLike)
        
        
    }
}
