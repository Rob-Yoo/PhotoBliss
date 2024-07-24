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
    }
    
    enum Output {
        case topicList(_ topicList: [TopicModel])
        case networkError(_ message: String)
    }
    
    private let output = Observable<Output>()
    private let repository = TopicTrendRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                Task { await self.fetchTopicList() }
            }
        }
        return output
    }
}

extension TopicTrendViewModel {
    private func fetchTopicList() async {
        let result = await repository.fetchTopicList()
        
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
