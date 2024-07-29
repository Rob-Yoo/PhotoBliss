//
//  PhotoDetailViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation
import UIKit.UIImage

final class PhotoDetailViewModel {
    enum Input {
        case shouldLoadPhotoDetail
        case likeButtonTapped(image: UIImage)
    }
    
    enum Output {
        case photoDetail(_ info: PhotoDetailModel)
        case networkError(_ message: String)
    }
    
    private let photoCellModel: PhotoCellModel
    private var isLike = false
    private let output = Observable<Output>()
    private let detailRepository = PhotoDetailRepository()
    private let likeRepository = PhotoLikeRepository()

    init(photo: PhotoCellModel) {
        self.photoCellModel = photo
    }
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .shouldLoadPhotoDetail:
                Task { await self.fetchPhotoDetailModel() }
            case .likeButtonTapped(let image):
                self.updatePhotoLike(photo: photoCellModel, image: image)
            }
        }
        
        return output
    }
}

extension PhotoDetailViewModel {
    private func fetchPhotoDetailModel() async {
        let result = await detailRepository.fetchPhotoDetail(photo: self.photoCellModel)
        let likeList = await fetchPhotoLikeList()
        
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(var photoDetail):
                let isLike = likeList.contains(where: { $0.id == photoDetail.photo.id })
                
                self?.isLike = isLike
                photoDetail.photo.isLike = isLike
                self?.output.value = .photoDetail(photoDetail)
            case .failure(let error):
                self?.handleTempPhotoDetail(likeList: likeList, error: error as NSError)
                self?.output.value = .networkError(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func fetchPhotoLikeList() -> [PhotoCellModel] {
        return self.likeRepository.fetchPhotoLikeList()
    }
    
    private func handleTempPhotoDetail(likeList: [PhotoCellModel], error: NSError) {
        let userInfoKey = String(describing: PhotoDetailModel.self)
        guard var tempPhotoDetail = error.userInfo[userInfoKey] as? PhotoDetailModel else { return }
        let isLike = likeList.contains(where: { $0.id == tempPhotoDetail.photo.id })
        
        self.isLike = isLike
        tempPhotoDetail.photo.isLike = isLike
        self.output.value = .photoDetail(tempPhotoDetail)
    }
    
    private func updatePhotoLike(photo: PhotoCellModel, image: UIImage) {
        if (self.isLike) {
            self.likeRepository.removePhotoLike(photo: photo)
        } else {
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            self.likeRepository.savePhotoLike(photo: photo, imageData: data)
        }
        
        self.isLike.toggle()
    }
}
