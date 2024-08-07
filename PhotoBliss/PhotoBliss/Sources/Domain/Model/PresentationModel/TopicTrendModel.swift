//
//  TopicModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct TopicModel {
    let title: String
    let trendPhotos: [PhotoCellModel]

    static func createTopicModel(title: String, dtos: [PhotoDTO]) -> Self {
        var trendPhotos = [PhotoCellModel]()
        
        dtos.forEach {
            let photoModel = PhotoCellModel.createPhotoCellModel(dto: $0)
            trendPhotos.append(photoModel)
        }
        return TopicModel(title: title, trendPhotos: trendPhotos)
    }
}
