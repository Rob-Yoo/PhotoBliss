//
//  PhotoDetailModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

struct PhotoDetailModel {
    var photo: PhotoCellModel
    let viewCount: Int
    let downloadCount: Int
    
    static func createPhotoDetailModel(photo: PhotoCellModel, photoStatistic: PhotoStatisticDTO) -> Self {

        return PhotoDetailModel(photo: photo, viewCount: photoStatistic.views.total, downloadCount: photoStatistic.downloads.total)
    }
    
    
}
