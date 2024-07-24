//
//  TopicTrendViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit

final class TopicTrendViewController: BaseViewController<TopicTrendRootView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .hidden)
        let photo = PhotoModel(id: "asdfzxcv", imageURL: "https://images.unsplash.com/photo-1721227043465-40fb34f25d26?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MzY0NjZ8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgxNzM0OHw&ixlib=rb-4.0.3&q=85", starCount: 1000, isLike: false)
        let topicList = [
            TopicModel(name: "골든 아워", trendPhotos: [photo, photo, photo, photo, photo]),
            TopicModel(name: "비즈니스", trendPhotos: [photo, photo, photo, photo, photo]),
            TopicModel(name: "건축", trendPhotos: [photo, photo, photo, photo, photo])
        ]
        
        self.contentView.updateUI(data: topicList)
    }
}
