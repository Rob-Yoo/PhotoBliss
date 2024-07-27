//
//  PhotoSearchService.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import Foundation

//MARK: - ViewModel <-> Service <-> Repository

final class PhotoSearchService {
    private let seachRepository = PhotoSearchRepository()
    private let likeRepository = PhotoLikeRepository()
    
    func fetchPhotoList(fetchType: PhotoSearchDomain.FetchType) async -> Result<[PhotoCellModel], Error> {
        let searchResult = await seachRepository.fetchPhotoList(fetchType: fetchType)
        let photoLikeList = await fetchPhotoLikeList()
        let photoLikeSet = Set(photoLikeList)
        var finalPhotoList = [PhotoCellModel]()
        
        switch searchResult {
        case .success(let photoList):
            
            for photo in photoList {
                var photo = photo
                let isLike = photoLikeSet.contains(photo)

                photo.isLike = isLike
                finalPhotoList.append(photo)
            }
            
            return .success(finalPhotoList)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func savePhotoLike(photo: PhotoCellModel, imageData: Data) {
        self.likeRepository.savePhotoLike(photo: photo, imageData: imageData)
    }
    
    func removePhotoLike(photo: PhotoCellModel) {
        self.likeRepository.removePhotoLike(photo: photo)
    }
}

extension PhotoSearchService {
    @MainActor
    private func fetchPhotoLikeList() -> [PhotoCellModel] {
        return self.likeRepository.fetchPhotoLikeList()
    }
}
