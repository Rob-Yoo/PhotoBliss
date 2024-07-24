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
        let topicList = await repository.fetchTopicList()
        guard !topicList.isEmpty else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.output.value = .topicList(topicList)
        }
    }
}
