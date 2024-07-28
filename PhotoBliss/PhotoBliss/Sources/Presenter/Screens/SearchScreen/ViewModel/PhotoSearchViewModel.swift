//
//  PhotoSearchViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation
import UIKit.UIImage

final class PhotoSearchViewModel {
    
    enum Input {
        case viewDidLoad
        case inputEmptyStatus(_ status: EmptyStatus)
        case searchButtonTapped(_ text: String)
        case orderByButtonTapped
        case colorButtonTapped(_ color: Color)
        case doPagination(_ currentPhotolist: [PhotoCellModel])
        case likeButtonTapped(photo: PhotoCellModel, image: UIImage)
    }
    
    enum Output {
        case outputEmptyStatus(_ status: EmptyStatus)
        case photoList(_ list: [PhotoCellModel])
        case orderByDidChange
        case shouldScrollUp(_ value: Bool)
        case networkError(_ message: String)
    }
    
    private var isEmptyResult = true
    private var orderBy: OrderBy = .relevant
    private let output = Observable<Output>()
    private let service = PhotoSearchService()
    
    func tranform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                self.output.value = .outputEmptyStatus(.emptySearchKeyword)
                
            case .inputEmptyStatus(let status):
                self.isEmptyResult = true
                self.output.value = .outputEmptyStatus(status)
                
            case .searchButtonTapped(let text):
                Task { await self.fetchPhotoList(fetchType: .searchText(text)) }
                
            case .orderByButtonTapped:
                self.orderBy = self.orderBy.toggle()
                self.output.value = .orderByDidChange
                guard !self.isEmptyResult, let orderBy = PhotoSearchDomain.OrderBy(rawValue: self.orderBy.rawValue) else { return }
                Task { await self.fetchPhotoList(fetchType: .orderBy(orderBy)) }
                
            case .colorButtonTapped(let color):
                guard !self.isEmptyResult, let color = PhotoSearchDomain.Color(rawValue: color.rawValue) else { return }
                Task { await self.fetchPhotoList(fetchType: .color(color)) }
                
            case .doPagination(let list):
                Task { await self.fetchPhotoList(fetchType: .page, currentPhotoList: list) }
                
            case .likeButtonTapped(let photo, let image):
                self.updatePhotoLike(photo: photo, image: image)
            }
        }
        
        return output
    }
}

extension PhotoSearchViewModel {
    private func fetchPhotoList(fetchType: PhotoSearchDomain.FetchType, currentPhotoList: [PhotoCellModel] = []) async {
        let result = await service.fetchPhotoList(fetchType: fetchType)

        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let photoList):
                var currentPhotoList = currentPhotoList
                let shouldScrollUp = currentPhotoList.isEmpty && !photoList.isEmpty
                let isLastPage = !currentPhotoList.isEmpty && photoList.isEmpty
                
                guard !isLastPage else { return }
                
                currentPhotoList.append(contentsOf: photoList)
                if (currentPhotoList.isEmpty) {
                    self?.isEmptyResult = true
                    self?.output.value = .outputEmptyStatus(.emptySearchResult) }
                else {
                    self?.isEmptyResult = false
                    self?.output.value = .photoList(currentPhotoList)
                    self?.output.value = .shouldScrollUp(shouldScrollUp)
                }
            case .failure(let error):
                self?.output.value = .networkError(error.localizedDescription)
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

extension PhotoSearchViewModel {
    enum EmptyStatus {
        case emptySearchKeyword
        case emptySearchResult
        
        var labelText: String {
            switch self {
            case .emptySearchKeyword:
                return Literal.PhotoSearch.emptySearchKeyword
            case .emptySearchResult:
                return Literal.PhotoSearch.emptySearchResult
            }
        }
    }
    
    enum OrderBy: String {
        case relevant
        case latest
        
        func toggle() -> Self {
            switch self {
            case .relevant:
                return .latest
            case .latest:
                return .relevant
            }
        }
    }
    
    enum Color: String {
        case black, white, yellow, red, purple, green, blue
    }
}
