//
//  PhotoLikeViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import Foundation
import UIKit.UIImage

final class PhotoLikeViewModel {
    enum Input {
        case viewIsAppearing
        case orderByButtonTapped
        case likeButtonTapped(photo: PhotoCellModel)
    }
    
    enum Output {
        case photoLikeList(_ list: [PhotoCellModel])
        case resetOrderByButton
        case orderByDidChange
        case isEmptyList
    }
    
    private lazy var photoLikeList = self.repository.fetchPhotoLikeList()
    private var orderByOption: OrderBy = .latest
    private let output = Observable<Output>()
    private let repository = PhotoLikeRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewIsAppearing:
                self.fetchPhotoLikeList()
            case .orderByButtonTapped:
                self.orderByOption = self.orderByOption.toggle()
                self.output.value = .orderByDidChange
                self.fetchPhotoLikeList()
            case .likeButtonTapped(photo: let photo):
                self.removePhotoLike(photo: photo)
            }
        }
        
        return output
    }
}

extension PhotoLikeViewModel {
    private func fetchPhotoLikeList() {
        let photoLikeList: [PhotoCellModel]
        
        switch self.orderByOption {
        case .latest:
            photoLikeList = self.repository.fetchPhotoLikeList().reversed()
        case .oldest:
            photoLikeList = self.repository.fetchPhotoLikeList()
        }

        if (photoLikeList.isEmpty) {
            self.orderByOption = .latest
            self.output.value = .isEmptyList
        } else {
            self.output.value = .photoLikeList(photoLikeList)
        }
        
        self.photoLikeList = photoLikeList
    }
    
    private func removePhotoLike(photo: PhotoCellModel) {
        self.repository.removePhotoLike(photo: photo)
        
        if (self.photoLikeList.count == 1) {
            self.output.value = .resetOrderByButton
        }
        
        self.fetchPhotoLikeList()
    }
}

extension PhotoLikeViewModel {
    enum OrderBy {
        case latest
        case oldest
        
        func toggle() -> Self {
            switch self {
            case .latest:
                return .oldest
            case .oldest:
                return .latest
            }
        }
    }
}
