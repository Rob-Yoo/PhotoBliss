//
//  PhotoDetailViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

final class PhotoDetailViewModel {
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case photoDetail(_ info: PhotoDetailModel)
        case networkError(_ message: String)
    }
    
    private let photoCellModel: PhotoCellModel
    private let output = Observable<Output>()
    private let repository = PhotoDetailRepository()

    init(photo: PhotoCellModel) {
        self.photoCellModel = photo
    }
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .viewDidLoad:
                Task { await self.fetchPhotoDetailModel() }
            }
        }
        
        return output
    }
}

extension PhotoDetailViewModel {
    private func fetchPhotoDetailModel() async {
        let result = await repository.fetchPhotoDetail(photo: self.photoCellModel)

        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let photoDetail):
                self?.output.value = .photoDetail(photoDetail)
            case .failure(let error):
                self?.output.value = .networkError(error.localizedDescription)
            }
        }
    }
}
