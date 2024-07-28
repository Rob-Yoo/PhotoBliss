//
//  PhotoDetailRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

final class PhotoDetailRepository {
    
    func fetchPhotoDetail(photo: PhotoCellModel) async -> Result<PhotoDetailModel, Error> {
        let result = await NetworkManger.shared.requestAPI(req: .statistic(imageID: photo.id), type: PhotoStatisticDTO.self)
        
        switch result {
        case .success(let data):
            let photoDetail = PhotoDetailModel.createPhotoDetailModel(photo: photo, photoStatistic: data)
            return .success(photoDetail)
        case .failure(let error):
            return .failure(error)
        }
    }

}
