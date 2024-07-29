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
    private var monitorArray = [Int: NWPathMonitor]()
    private var monitorStateArray = [Int: Bool]()
    private var nextMonitorId = 0
    
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
    
    func doMonitoringNetwork(reconnectHandler: @escaping () -> Void) -> Int {
        let monitor = NWPathMonitor()
        let monitorId = nextMonitorId
        
        self.nextMonitorId += 1
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            if path.status == .satisfied, monitorStateArray[monitorId] == false {
                
                DispatchQueue.main.async {
                    reconnectHandler()
                }
                
                monitorStateArray[monitorId] = true
            } else if path.status == .satisfied {
                monitorStateArray[monitorId] = true
            } else if path.status == .unsatisfied {
                monitorStateArray[monitorId] = false
            }
        }
        
        monitor.start(queue: DispatchQueue.global())
        self.monitorArray[monitorId] = monitor
        self.monitorStateArray[monitorId] = true
        
        return monitorId
    }
    
    func stopNetworkMonitoring(monitorId: Int) {
        guard let monitor = self.monitorArray[monitorId] else { return }
        
        monitor.cancel()
        self.monitorArray.removeValue(forKey: monitorId)
        self.monitorStateArray.removeValue(forKey: monitorId)
    }
}
