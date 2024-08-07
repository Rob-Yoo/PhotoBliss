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
        case wallpapers
        case nature
        case ThreeDimensionRenders = "3d-renders"
        case travel
        case texturesPatterns = "textures-patterns"
        case streetPhotography = "street-photography"
        case film
        case archival
        case experimental
        case animals
        case fashionBeauty = "fashion-beauty"
        case people
        case foodDrink = "food-drink"
        
        var title: String {
            switch self {
            case .goldenHour:
                return "골든 아워"
            case .businessWork:
                return "비즈니스 및 업무"
            case .architectureInterior:
                return "건축 및 인테리어"
            case .wallpapers:
                return "배경 화면"
            case .nature:
                return "자연"
            case .ThreeDimensionRenders:
                return "3D 렌더링"
            case .travel:
                return "여행"
            case .texturesPatterns:
                return "텍스쳐 및 패턴"
            case .streetPhotography:
                return "거리 사진"
            case .film:
                return "필름"
            case .archival:
                return "기록의"
            case .experimental:
                return "실험적인"
            case .animals:
                return "동물"
            case .fashionBeauty:
                return "패션 및 뷰티"
            case .people:
                return "사람"
            case .foodDrink:
                return "식음료"
            }
        }
    }
    
    func fetchTopicList() async -> Result<[TopicModel], Error> {
        let queryDTO = TopicTrendQueryDTO(page: 1, client_id: APIKey.key)
        let randomTopics = Topic.allCases.shuffled().prefix(3)
        var topicList = [TopicModel]()

        for topic in randomTopics {
            let result = await NetworkManger.shared.requestAPI(req: .topic(topicID: topic.rawValue, queryDTO: queryDTO), type: [PhotoDTO].self)
            
            switch result {
            case .success(let topicTrendDTOs):
                let topicModel = TopicModel.createTopicModel(title: topic.title, dtos: topicTrendDTOs)
                topicList.append(topicModel)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(topicList)
    }
}
