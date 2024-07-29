//
//  NetworkManger.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Alamofire
import Network
import Foundation

final class NetworkManger {
    static let shared = NetworkManger()
    private let monitor = NWPathMonitor()
    private var isConnectedNetwork = true
    
    private init() {}
    
    func requestAPI<T: Decodable>(req: UnsplashRequest, type: T.Type) async -> Result<T, Error> {
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
    
    func doMornitoringNetwork(reconnectHandler: @escaping () -> Void, offlineHandler: (() -> Void)? = nil) {
        monitor.pathUpdateHandler = { [weak self] path in
            
            guard let self else { return }
            
            if path.status == .satisfied && isConnectedNetwork == false {
                reconnectHandler()
                isConnectedNetwork.toggle()
            } else if path.status == .unsatisfied && isConnectedNetwork == true {
                offlineHandler?()
                isConnectedNetwork.toggle()
            }
        }
        
        monitor.start(queue: DispatchQueue.global())
    }
    
    func stopNetworkMonitoring() {
        monitor.cancel()
    }
}
