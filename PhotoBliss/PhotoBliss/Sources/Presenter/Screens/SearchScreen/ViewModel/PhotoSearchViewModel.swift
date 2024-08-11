//
//  PhotoSearchViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation
import UIKit

final class PhotoSearchViewModel {
    
    enum Input {
        case viewDidLoad
        case shouldUpdatePhotoLike
        case inputEmptyStatus(_ status: EmptyStatus)
        case searchButtonTapped(_ text: String)
        case orderByButtonTapped
        case colorButtonTapped(_ color: Color)
        case doPagination
        case likeButtonTapped(photo: PhotoCellModel, image: UIImage)
    }
    
    enum Output {
        case outputEmptyStatus(_ status: EmptyStatus)
        case photoList(_ list: [PhotoCellModel])
        case orderByDidChange
        case shouldScrollUp(_ value: Bool)
        case networkError(_ message: String)
    }
    
    private var photoList = [PhotoCellModel]()
    private var orderBy: OrderBy = .relevant
    private var isEmptyResult: Bool {
        return photoList.isEmpty
    }

    private let output = Observable<Output>()
    private let service = PhotoService()
    
    func tranform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }

            switch event {
            case .viewDidLoad:
                output.value = .outputEmptyStatus(.emptySearchKeyword)
                
            case .shouldUpdatePhotoLike:
                updatePhotoLike()
                
            case .inputEmptyStatus(let status):
                photoList = []
                output.value = .outputEmptyStatus(status)
                
            case .searchButtonTapped(let text):
                Task { await self.fetchPhotoList(fetchType: .searchText(text)) }
                
            case .orderByButtonTapped:
                changeOrderByOption()

            case .colorButtonTapped(let color):
                guard !isEmptyResult, let color = PhotoSearchDomain.Color(rawValue: color.rawValue) else { return }
                Task { await self.fetchPhotoList(fetchType: .color(color)) }
                
            case .doPagination:
                Task { await self.fetchPhotoList(fetchType: .page) }
                
            case .likeButtonTapped(let photo, let image):
                updatePhotoLike(photo: photo, image: image)
            }
        }
        
        return output
    }
}

extension PhotoSearchViewModel {
    private func fetchPhotoList(fetchType: PhotoSearchDomain.FetchType) async {
        let result = await service.fetchSearchResult(fetchType: fetchType)

        switch fetchType {
        case .page:
            break
        default:
            self.photoList = []
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            switch result {
            case .success(let newPhotoList):

                let shouldScrollUp = self.isEmptyResult && !newPhotoList.isEmpty
                let isLastPage = !self.isEmptyResult && newPhotoList.isEmpty
                
                guard !isLastPage else { return }
                
                photoList.append(contentsOf: newPhotoList)
                if (isEmptyResult) {
                    output.value = .outputEmptyStatus(.emptySearchResult) }
                else {
                    output.value = .photoList(self.photoList)
                    output.value = .shouldScrollUp(shouldScrollUp)
                }
                
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
    
    private func changeOrderByOption() {
        guard !self.isEmptyResult else { return }

        self.orderBy.toggle()
        self.output.value = .orderByDidChange
        
        guard let orderBy = PhotoSearchDomain.OrderBy(rawValue: self.orderBy.rawValue) else { return }
        Task { await self.fetchPhotoList(fetchType: .orderBy(orderBy)) }
    }
    
    private func updatePhotoLike() {
        guard !self.isEmptyResult else { return }
        
        let updatedPhotoList = self.service.updatePhotoLikeList(currentList: self.photoList)
        
        self.output.value = .photoList(updatedPhotoList)
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
        
        mutating func toggle() {
            switch self {
            case .relevant:
                self = .latest
            case .latest:
                self = .relevant
            }
        }
    }
    
    enum Color: String, CaseIterable {
        case black, yellow, red, purple, green, blue
        
        var title: String {
            switch self {
            case .black:
                return "블랙"
            case .yellow:
                return "옐로우"
            case .red:
                return "레드"
            case .purple:
                return "퍼플"
            case .green:
                return "그린"
            case .blue:
                return "블루"
            }
        }
        
        var color: UIColor {
            switch self {
            case .black:
                return .black
            case .yellow:
                return .yellow
            case .red:
                return .red
            case .purple:
                return .purple
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }
}
