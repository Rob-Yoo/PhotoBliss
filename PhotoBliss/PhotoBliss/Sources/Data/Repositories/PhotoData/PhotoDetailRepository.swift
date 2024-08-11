//
//  PhotoDetailRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation
import Alamofire

final class PhotoDetailRepository {
    
    func fetchPhotoDetail(photo: PhotoCellModel) async -> Result<PhotoDetailModel, Error> {
        let result = await NetworkManger.shared.requestAPI(req: .statistic(imageID: photo.id), type: PhotoStatisticDTO.self)
        
        switch result {
        case .success(let data):
            let photoDetail = PhotoDetailModel.createPhotoDetailModel(photo: photo, photoStatistic: data)
            return .success(photoDetail)
        case .failure(let error):
            let tempPhotoDetail = PhotoDetailModel.createPhotoDetailModel(photo: photo)
            let userInfoKey = String(describing: PhotoDetailModel.self)
            let customError = NSError(domain: "네트워크 연결 문제가 발생하였습니다.", code: 400, userInfo: [userInfoKey: tempPhotoDetail])

            return .failure(customError)
        }
    }

}
