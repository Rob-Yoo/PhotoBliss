//
//  PhotoSearchViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

final class PhotoSearchViewModel {
    
    enum Input {
        case viewDidLoad
        case inputEmptyStatus(_ status: EmptyStatus)
        case searchButtonTapped(_ text: String)
        case sortButtonTapped(_ orderBy: OrderBy)
        case colorButtonTapped(_ color: Color)
        case doPagination(_ currentPhotolist: [PhotoCellModel])
    }
    
    enum Output {
        case outputEmptyStatus(_ status: EmptyStatus)
        case photoList(_ list: [PhotoCellModel])
        case shouldScrollUp(_ value: Bool)
        case networkError(_ message: String)
    }
    
    private let output = Observable<Output>()
    private let repository = PhotoSearchRepository()
    
    func tranform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                self.output.value = .outputEmptyStatus(.emptySearchKeyword)
                
            case .inputEmptyStatus(let status):
                self.output.value = .outputEmptyStatus(status)
                
            case .searchButtonTapped(let text):
                Task { await self.fetchPhotoList(fetchType: .searchText(text)) }
                
            case .sortButtonTapped(let orderBy):
                Task { await self.fetchPhotoList(fetchType: .orderBy(orderBy)) }
                
            case .colorButtonTapped(let color):
                Task { await self.fetchPhotoList(fetchType: .color(color)) }
                
            case .doPagination(let list):
                Task { await self.fetchPhotoList(fetchType: .page, currentPhotoList: list) }
            }
        }
        
        return output
    }
}

extension PhotoSearchViewModel {
    private func fetchPhotoList(fetchType: PhotoSearchRepository.FetchType, currentPhotoList: [PhotoCellModel] = []) async {
        let result = await repository.fetchPhotoList(fetchType: fetchType)

        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let photoList):
                var currentPhotoList = currentPhotoList
                let shouldScrollUp = currentPhotoList.isEmpty && !photoList.isEmpty
                let isLastPage = !currentPhotoList.isEmpty && photoList.isEmpty
                
                guard !isLastPage else { return }
                
                currentPhotoList.append(contentsOf: photoList)
                if (currentPhotoList.isEmpty) {
                    self?.output.value = .outputEmptyStatus(.emptySearchResult) }
                else {
                    self?.output.value = .photoList(currentPhotoList)
                    self?.output.value = .shouldScrollUp(shouldScrollUp)
                }
            case .failure(let error):
                self?.output.value = .networkError(error.localizedDescription)
            }
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
    }
    
    enum Color: String {
        case black, white, yellow, red, purple, green, blue
    }
}
