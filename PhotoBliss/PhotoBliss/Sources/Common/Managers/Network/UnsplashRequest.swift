//
//  UnsplashRequest.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Alamofire

enum UnsplashRequest {
    case topic(topicID: String)
    
    private var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var endPoint: String {
        switch self {
        case .topic(let topicID):
            return baseURL + "/topics/\(topicID)/photos"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .topic(_):
            return ["page": 1, "client_id": APIKey.key]
        }
    }
}
