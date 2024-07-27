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
        case orderBy(_ orderBy: OrderBy)
        case likeButtonTapped(photo: PhotoCellModel)
    }
    
    enum Output {
        case photoLikeList(_ list: [PhotoCellModel])
        case isEmptyList
    }
    
    private var orderByOption: OrderBy = .latest
    private let output = Observable<Output>()
    private let repository = PhotoLikeRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            switch event {
            case .viewIsAppearing:
                self?.fetchPhotoLikeList()
            case .orderBy(let orderBy):
                self?.orderByOption = orderBy
                self?.fetchPhotoLikeList()
            case .likeButtonTapped(photo: let photo):
                self?.removePhotoLike(photo: photo)
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
            self.output.value = .isEmptyList
        } else {
            self.output.value = .photoLikeList(photoLikeList)
        }
    }
    
    private func removePhotoLike(photo: PhotoCellModel) {
        self.repository.removePhotoLike(photo: photo)
        self.fetchPhotoLikeList()
    }
}

extension PhotoLikeViewModel {
    enum OrderBy {
        case latest
        case oldest
    }
}
