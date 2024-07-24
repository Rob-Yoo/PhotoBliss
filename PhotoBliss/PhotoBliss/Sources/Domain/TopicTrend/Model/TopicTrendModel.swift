//
//  TopicModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct TopicModel {
    let title: String
    let trendPhotos: [PhotoModel]

    static func createTopicModel(title: String, dtos: [TopicTrendDTO]) -> Self {
        var trendPhotos = [PhotoModel]()
        
        dtos.forEach {
            let photoModel = PhotoModel.createPhotoModel(dto: $0)
            trendPhotos.append(photoModel)
        }
        return TopicModel(title: title, trendPhotos: trendPhotos)
    }
}
