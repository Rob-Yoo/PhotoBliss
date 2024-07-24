//
//  TopicTrendViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import Toast

final class TopicTrendViewController: BaseViewController<TopicTrendRootView> {
    
    private let input = Observable<TopicTrendViewModel.Input>(.viewDidLoad)
    private let viewModel = TopicTrendViewModel()
    
    override func viewDidLoad() {
        self.contentView.makeToastActivity(.center)
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .hidden)
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] event in
                self?.contentView.hideToastActivity()

                switch event {
                case .topicList(let topicList):
                    self?.contentView.updateUI(data: topicList)
                case .networkError(let message):
                    self?.showAlert(message: message)
                }
            }
    }
}
