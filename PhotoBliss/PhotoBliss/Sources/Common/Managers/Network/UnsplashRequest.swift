//
//  UnsplashRequest.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Alamofire

enum UnsplashRequest {
    case topic(topicID: String, queryDTO: TopicTrendQueryDTO)
    case search(query: PhotoSearchQueryDTO)
    
    private var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var endPoint: String {
        switch self {
        case .topic(let topicID, _):
            return baseURL + "/topics/\(topicID)/photos"
        case .search:
            return baseURL + "/search/photos"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Encodable {
        switch self {
        case .topic(_, let queryDTO):
            return queryDTO
        case .search(let query):
            return query
        }
    }
}
