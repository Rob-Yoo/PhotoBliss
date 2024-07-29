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
    
    private let input = Observable<TopicTrendViewModel.Input>()
    private let viewModel = TopicTrendViewModel()
    private var monitorId: Int?
    
    private lazy var profileImageView = ProfileImageView().then {
        let size = self.navigationController?.navigationBar.frame.height ?? 44

        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .unselected
        $0.layer.borderColor = UIColor.mainTheme.cgColor
        $0.layer.borderWidth = 3
        $0.alpha = 1
        $0.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
    }
    
    override func viewDidLoad() {
        self.contentView.makeToastActivity(.center)
        super.viewDidLoad()
        self.configureNavigationRightBarButtonItem()
        self.addNetworkMonitor()
        self.input.value = .viewDidLoad
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.configureNavBarAppearence(appearenceType: .transparent)
        self.input.value = .reloadUserProfileImage
    }
    
    deinit {
        print("Topic Trend Deinit")
        guard let monitorId else { return }
        
        NetworkManger.shared.stopNetworkMonitoring(monitorId: monitorId)
    }

    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] output in
                
                guard let self else { return }
                
                switch output {
                    
                case .topicList(let topicList):
                    contentView.updateUI(data: topicList)
                    
                case .userProfileImageNumber(let number):
                    updateProfileImage(imageNumber: number)
                    
                case .networkError(let message):
                    showNetworkErrorAlert(message: message)
                    
                }

                contentView.hideToastActivity()
            }
    }
    
    private func configureNavigationRightBarButtonItem() {
        let barButton = UIBarButtonItem(customView: profileImageView)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        profileImageView.addGestureRecognizer(tapGR)
    }
    
    private func addNetworkMonitor() {
        let id = NetworkManger.shared.doMonitoringNetwork { [weak self] in
            self?.input.value = .shouldRefresh
        }
        
        self.monitorId = id
    }
}

//MARK: - User Action Handling
extension TopicTrendViewController: TopicTrendRootViewDelegate {
    func refresh() {
        self.input.value = .shouldRefresh
    }
    
    @objc private func profileImageViewTapped() {
        let nextVC = EditProfileSettingViewController(contentView: ProfileSettingRootView(type: .Editing))

        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - Update UI
extension TopicTrendViewController {
    private func updateProfileImage(imageNumber: Int) {
        let size = self.navigationController?.navigationBar.frame.height ?? 44

        self.profileImageView.image = UIImage.profileImages[imageNumber].resizeImage(size: CGSize(width: size, height: size))
    }
    
    
}
