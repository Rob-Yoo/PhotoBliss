//
//  PhotoSearchQueryModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

struct PhotoSearchQueryModel {
    
    enum OrderBy: String {
        case relevant
        case latest
    }
    
    enum Color: String {
        case black, white, yellow, red, purple, green, blue
    }
    
    private var searchText: String = ""
    private(set) var page: Int = 1
    private let perPage: Int = 20
    private var orderBy: OrderBy = .relevant
    private var color: Color? = nil
    private let clientID: String = APIKey.key
}

extension PhotoSearchQueryModel {
    mutating func makeQueryDTO(type: PhotoSearchRepository.FetchType) -> Result<PhotoSearchQueryDTO, Error> {
        
        switch type {
        case .searchText(let text):
            self.searchText = text
            self.page = 1
            
        case .page:
            self.page += 1
            
        case .color(let color):
            guard let color = Color(rawValue: color.rawValue) else {
                return .failure(NSError(domain: "더이상 지원하지 않는 컬러 옵션입니다.", code: 404))
            }
            
            self.color = color
            self.page = 1
            
        case .orderBy(let orderBy):
            guard let orderBy = OrderBy(rawValue: orderBy.rawValue) else {
                return .failure(NSError(domain: "더이상 지원하지 않는 정렬 옵션입니다.", code: 404))
            }
            
            self.orderBy = orderBy
            self.page = 1
        }
        
        return .success(convertToDTO())
    }
    
    private func convertToDTO() -> PhotoSearchQueryDTO {
        return PhotoSearchQueryDTO(query: searchText, page: page, per_page: perPage, order_by: orderBy.rawValue, color: color?.rawValue, client_id: clientID)
    }
}
