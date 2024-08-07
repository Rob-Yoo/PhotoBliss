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
    
    private let photo: PhotoCellModel
    private var isLike = false
    private let output = Observable<Output>()
    private let service = PhotoService()

    init(photo: PhotoCellModel) {
        self.photo = photo
    }
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .shouldLoadPhotoDetail:
                Task { await self.fetchPhotoDetailModel() }
            case .likeButtonTapped(let image):
                updatePhotoLike(photo: photo, image: image)
            }
        }
        
        return output
    }
}

extension PhotoDetailViewModel {
    private func fetchPhotoDetailModel() async {
        let result = await service.fetchPhotoDetail(from: photo)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch result {
            
            case .success(let photoDetail):
                self.isLike = photoDetail.photo.isLike
                self.output.value = .photoDetail(photoDetail)
            
            case .failure(let error):
                let userInfoKey = String(describing: PhotoDetailModel.self)
                guard let tempPhotoDetail = (error as NSError) .userInfo[userInfoKey] as? PhotoDetailModel else { return }
                
                self.isLike = tempPhotoDetail.photo.isLike
                self.output.value = .photoDetail(tempPhotoDetail)
                self.output.value = .networkError(error.localizedDescription)
            }
        }
    }
    
    private func updatePhotoLike(photo: PhotoCellModel, image: UIImage) {
        if (self.isLike) {
            self.service.removePhotoLike(photo: photo)
        } else {
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            self.service.savePhotoLike(photo: photo, imageData: data)
        }
        
        self.isLike.toggle()
    }
}
