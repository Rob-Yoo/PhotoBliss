//
//  PhotoSearchRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

final class PhotoSearchRepository {

    private var searchQuery = PhotoSearchQueryModel()
    private var totalPages = -1
    
    // MARK: - Repository <-> Service
    func fetchPhotoList(fetchType: PhotoSearchDomain.FetchType) async -> Result<[PhotoCellModel], Error> {
        
        switch fetchType {
        case .page:
            if (totalPages < searchQuery.page + 1) { return .success([]) }
        default:
            self.totalPages = -1
        }
        
        let result = await fetchSearchResult(fetchType: fetchType)
        
        switch result {
        case .success(let data):
            if totalPages == -1 { self.totalPages = data.totalPages }
            let photoList = data.results.map { PhotoCellModel.createPhotoCellModel(dto: $0) }

            return .success(photoList)
        case .failure(let error):
            return .failure(error)
        }
    }
}

//MARK: - Server <-> Repository
extension PhotoSearchRepository {
    private func fetchSearchResult(fetchType: PhotoSearchDomain.FetchType) async -> Result<PhotoSearchResultDTO, Error> {
        let searchQueryDTO = searchQuery.makeQueryDTO(type: fetchType)
        let result = await NetworkManger.requestAPI(req: .search(query: searchQueryDTO), type: PhotoSearchResultDTO.self)
        
        return result
    }
}
