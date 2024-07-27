//
//  PhotoSearchQueryModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

struct PhotoSearchQueryModel {
    private var searchText: String = ""
    private(set) var page: Int = 1
    private let perPage: Int = 20
    private var orderBy: PhotoSearchDomain.OrderBy = .relevant
    private var color: PhotoSearchDomain.Color? = nil
    private let clientID: String = APIKey.key
}

extension PhotoSearchQueryModel {
    mutating func makeQueryDTO(type: PhotoSearchDomain.FetchType) -> PhotoSearchQueryDTO {
        
        switch type {
        case .searchText(let text):
            self.searchText = text
            self.page = 1
            
        case .page:
            self.page += 1
            
        case .color(let color):
            self.color = color
            self.page = 1
            
        case .orderBy(let orderBy):
            self.orderBy = orderBy
            self.page = 1
        }
        
        return convertToDTO()
    }
    
    private func convertToDTO() -> PhotoSearchQueryDTO {
        return PhotoSearchQueryDTO(query: searchText, page: page, per_page: perPage, order_by: orderBy.rawValue, color: color?.rawValue, client_id: clientID)
    }
}
