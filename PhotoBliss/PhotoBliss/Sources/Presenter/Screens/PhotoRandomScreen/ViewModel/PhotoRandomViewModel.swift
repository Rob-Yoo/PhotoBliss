//
//  PhotoRandomViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 9/5/24.
//

import Foundation
import UIKit

final class PhotoRandomViewModel {
    
    enum Input {
        case viewDidLoad
        case likeButtonTapped(photo: PhotoCellModel, image: UIImage)
    }
    
    enum Output {
        case photoList(_ list: [PhotoCellModel])
        case networkError(_ message: String)
    }
    
    private let output = Observable<Output>()
    private let service = PhotoService()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .viewDidLoad:
                Task { await self.fetchPhotoList() }
                
            case .likeButtonTapped(let photo, let image):
                updatePhotoLike(photo: photo, image: image)
            }
        }
        
        return self.output
    }
}

extension PhotoRandomViewModel {
    
    private func fetchPhotoList() async {
        let result = await service.fetchRandomPhotoList()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch result {
            case .success(let newPhotoList):
                output.value = .photoList(newPhotoList)
            case .failure(let error):
                output.value = .networkError(error.localizedDescription)
            }
        }
    }
    
    private func updatePhotoLike(photo: PhotoCellModel, image: UIImage) {
        let isLike = photo.isLike
        
        if (isLike) {
            self.service.removePhotoLike(photo: photo)
        } else {
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            self.service.savePhotoLike(photo: photo, imageData: data)
        }
    }
}
