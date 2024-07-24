//
//  NetworkManger.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Alamofire

enum NetworkManger {
    static func requestAPI<T: Decodable>(req: UnsplashRequest, type: T.Type) async -> Result<T, Error> {
        do {
            let response = try await AF.request(req.endPoint,
                                                method: req.method,
                                                parameters: req.parameters,
                                                encoding: URLEncoding(destination: .queryString))
                .validate().serializingDecodable(type).value
            
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
