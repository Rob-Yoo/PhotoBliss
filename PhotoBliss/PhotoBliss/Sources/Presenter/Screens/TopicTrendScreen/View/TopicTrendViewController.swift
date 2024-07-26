//
//  TopicTrendViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then
import Toast

final class TopicTrendViewController: BaseViewController<TopicTrendRootView> {
    
    private let input = Observable<TopicTrendViewModel.Input>(.viewDidLoad)
    private let viewModel = TopicTrendViewModel()
    
    override func viewDidLoad() {
        self.contentView.makeToastActivity(.center)
        super.viewDidLoad()
        self.configureNavigationRightBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureNavBarAppearence(appearenceType: .transparent)
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] event in
                switch event {
                case .topicList(let topicList):
                    self?.contentView.updateUI(data: topicList)
                case .networkError(let message):
                    self?.showAlert(message: message)
                }

                self?.contentView.hideToastActivity()
            }
    }
    
    private func configureNavigationRightBarButtonItem() {
        let size = self.navigationController?.navigationBar.frame.height ?? 44
        let profileImageView = ProfileImageView().then {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .unselected
            $0.layer.borderColor = UIColor.mainTheme.cgColor
            $0.layer.borderWidth = 3
            $0.alpha = 1
            $0.image = .profile0.resizeImage(size: CGSize(width: size, height: size)) // BarButtonItem에 넣을 땐 Resizing 필수?!
            $0.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        }
        let barButton = UIBarButtonItem(customView: profileImageView)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        profileImageView.addGestureRecognizer(tapGR)
    }
}

//MARK: - User Action Handling
extension TopicTrendViewController: TopicTrendRootViewDelegate {
    func refresh() {
        self.input.value = .shouldRefresh
    }
    
    @objc private func profileImageViewTapped() {
        print("adsf")
    }
    
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
