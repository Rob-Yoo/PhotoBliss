//
//  TopicModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

struct TopicModel {
    let name: String
    let trendPhotos: [PhotoModel]
    
    static func createTopicModel(topic: String, dtos: [TopicTrendDTO]) -> Self {
        var trendPhotos = [PhotoModel]()
        
        dtos.forEach {
            let photoModel = PhotoModel.createPhotoModel(dto: $0)
            trendPhotos.append(photoModel)
        }
        return TopicModel(name: topic, trendPhotos: trendPhotos)
    }
}
