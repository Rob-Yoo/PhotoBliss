//
//  PhotoLikeDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import RealmSwift

final class PhotoLikeDTO: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var photoId: String
    @Persisted var starCount: Int
    @Persisted var photographerImageUrl: String
    @Persisted var photographerName: String
    @Persisted var publishedDate: String
    @Persisted var rawPhotoImageUrl: String
    @Persisted var width: Int
    @Persisted var height: Int

    convenience init(photo: PhotoCellModel) {
        self.init()
        self.photoId = photo.id
        self.starCount = photo.starCount
        self.photographerImageUrl = photo.photographerImageUrl
        self.photographerName = photo.photographerName
        self.publishedDate = photo.publishedDate
        self.rawPhotoImageUrl = photo.rawPhotoImageUrl
        self.width = photo.width
        self.height = photo.width
    }
    
}
