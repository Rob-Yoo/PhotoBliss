//
//  TopicTrendRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

final class TopicTrendRepository {
    
    private enum Topic: String, CaseIterable {
        case goldenHour = "golden-hour"
        case businessWork = "business-work"
        case architectureInterior = "architecture-interior"
        
        var title: String {
            switch self {
            case .goldenHour:
                return "골든 아워"
            case .businessWork:
                return "비즈니스 및 업무"
            case .architectureInterior:
                return "건축 및 인테리어"
            }
        }
    }
    
    func fetchTopicList() async -> [TopicModel] {
        var topicList = [TopicModel]()

        for topic in Topic.allCases {
            guard let topicTrendDTOs = await NetworkManger.requestAPI(req: .topic(topicID: topic.rawValue), type: [TopicTrendDTO].self) else {
                print("토픽별 트렌드 포토 관련 네트워크 통신 오류")
                return []
            }
            let topicModel = TopicModel.createTopicModel(topic: topic.title, dtos: topicTrendDTOs)

            topicList.append(topicModel)
        }
        
        return topicList
    }
}
