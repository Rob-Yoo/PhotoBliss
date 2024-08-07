//
//  TopicTrendViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import Foundation

final class TopicTrendViewModel {

    enum Input {
        case viewDidLoad
        case shouldRefresh
        case reloadUserProfileImage
    }
    
    enum Output {
        case topicList(_ topicList: [TopicModel])
        case userProfileImageNumber(_ number: Int)
        case networkError(_ message: String)
    }
    
    private let output = Observable<Output>()
    private let photoService = PhotoService()
    private let userDataRepository = UserDataRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            
            switch event {
                
            case .viewDidLoad:
                Task { await self.fetchTopicList() }
                
            case .shouldRefresh:
                Task { await self.fetchTopicList() }
                
            case .reloadUserProfileImage:
                output.value = .userProfileImageNumber(userDataRepository.loadProfileImageNumber())
            }
        }
        return output
    }
}

extension TopicTrendViewModel {
    private func fetchTopicList() async {
        let result = await photoService.fetchTopicTrendResult()
        
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let topicList):
                self?.output.value = .topicList(topicList)
            case .failure(let error):
                self?.output.value = .networkError(error.localizedDescription)
            }
        }
    }
}
