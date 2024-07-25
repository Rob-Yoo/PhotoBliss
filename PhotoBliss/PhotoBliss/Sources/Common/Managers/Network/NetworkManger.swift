//
//  NetworkManger.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Alamofire
import Foundation

enum NetworkManger {
    static func requestAPI<T: Decodable>(req: UnsplashRequest, type: T.Type) async -> Result<T, Error> {
        let response = await AF.request(req.endPoint,
                                            method: req.method,
                                            parameters: req.parameters,
                                            encoder: URLEncodedFormParameterEncoder.default)
            .validate().serializingDecodable(type).response
        
        if (response.response?.statusCode == 403) {
            return .failure(NSError(domain: "API 호출 한도수 초과", code: 403))
        }
        
        switch response.result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}
