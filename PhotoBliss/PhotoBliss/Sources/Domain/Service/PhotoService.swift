//
//  PhotoService.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 8/6/24.
//

import Foundation

final class PhotoService {
    private let searchRepository = PhotoSearchRepository()
    private let likeRepository = PhotoLikeRepository()
    private let detailRepository = PhotoDetailRepository()
    private let topicTrendRepoistory = TopicTrendRepository()
    private let randomPhotoRepository = RandomPhotoRepository()
}

//MARK: - Topic Trend
extension PhotoService {
    func fetchTopicTrendResult() async -> Result<[TopicModel], Error> {
        return await self.topicTrendRepoistory.fetchTopicList()
    }
}

//MARK: - Search Result
extension PhotoService {
    func fetchSearchResult(fetchType: PhotoSearchDomain.FetchType) async -> Result<[PhotoCellModel], Error> {
        let searchResult = await searchRepository.fetchPhotoList(fetchType: fetchType)
        let photoLikeList = await fetchLikeList()
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
}

//MARK: - Photo Detail(Statistic)
extension PhotoService {
    func fetchPhotoDetail(from photo: PhotoCellModel) async -> Result<PhotoDetailModel, Error> {
        let result = await detailRepository.fetchPhotoDetail(photo: photo)
        let likeList = await fetchLikeList()
        let likeSet = Set(likeList)
        
        switch result {
            
        case .success(var photoDetail):
            let isLike = likeSet.contains(where: { $0.id == photoDetail.photo.id })

            photoDetail.photo.isLike = isLike
            return .success(photoDetail)

        case .failure(let error):
            let userInfoKey = String(describing: PhotoDetailModel.self)
            guard var tempPhotoDetail = (error as NSError) .userInfo[userInfoKey] as? PhotoDetailModel else { return .failure(error)
            }
            let isLike = likeSet.contains(where: { $0.id == tempPhotoDetail.photo.id })
            let customError: NSError

            tempPhotoDetail.photo.isLike = isLike
            customError = NSError(domain: "네트워크 연결 문제가 발생하였습니다.", code: 400, userInfo: [userInfoKey: tempPhotoDetail])
            return .failure(customError)
        }
    }
    
}

//MARK: - Photo Like
extension PhotoService {
    func savePhotoLike(photo: PhotoCellModel, imageData: Data) {
        self.likeRepository.savePhotoLike(photo: photo, imageData: imageData)
    }
    
    func fetchPhotoLikeList() -> [PhotoCellModel] {
        return self.likeRepository.fetchPhotoLikeList()
    }
    
    @MainActor
    private func fetchLikeList() -> [PhotoCellModel] {
        return self.likeRepository.fetchPhotoLikeList()
    }
    
    func updatePhotoLikeList(currentList: [PhotoCellModel]) -> [PhotoCellModel] {
        var photoList = currentList
        let photoLikeList = self.likeRepository.fetchPhotoLikeList()
        let photoLikeSet = Set(photoLikeList)
        
        for (idx, photo) in photoList.enumerated() where photoLikeSet.contains(photo) {
            photoList[idx].isLike = true
        }
        
        return photoList
    }
    
    func removePhotoLike(photo: PhotoCellModel) {
        self.likeRepository.removePhotoLike(photo: photo)
    }
}

extension PhotoService {
    func fetchRandomPhotoList() async -> Result<[PhotoCellModel], Error>  {
        let randomPhotos = await self.randomPhotoRepository.fetchRandomPhotoList()
        let photoLikeList = await fetchLikeList()
        let photoLikeSet = Set(photoLikeList)
        var finalPhotoList = [PhotoCellModel]()

        switch randomPhotos {
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
}
