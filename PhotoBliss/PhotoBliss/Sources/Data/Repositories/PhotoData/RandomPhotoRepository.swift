//
//  RandomPhotoRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 9/5/24.
//

import Foundation

final class RandomPhotoRepository {
    func fetchRandomPhotoList() async -> Result<[PhotoCellModel], Error> {
        let result = await NetworkManger.shared.requestAPI(req: .randomPhoto, type: [PhotoDTO].self)
        
        switch result {
        case .success(let data):
            let photoList = data.map { PhotoCellModel.createPhotoCellModel(dto: $0) }

            return .success(photoList)
        case .failure(let error):
            return .failure(error)
        }
    }
}
