//
//  ProfileImageSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingRootView> {
    
    private let viewModel = ProfileImageSettingViewModel()
    private let input: Observable<ProfileImageSettingViewModel.Input>
    
    var deliverProfileImageNumber: ((Int) -> Void)?
    
    init(contentView: ProfileImageSettingRootView, profileImageNumber: Int) {
        self.input = Observable<ProfileImageSettingViewModel.Input>(.profileImageNumber(profileImageNumber))
        super.init(contentView: contentView)
    }

    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: input)
            .bind { [weak self] event in
                switch event {
                case .profileImageNumber(let number):
                    let profileImage = UIImage.profileImages[number]
                    
                    self?.contentView.updateUI(selectedImage: profileImage)
                    self?.deliverProfileImageNumber?(number)
                }
            }
    }
}

//MARK: - User Action Handling
extension ProfileImageSettingViewController: ProfileImageSettingRootViewDelegate {
    func profileImageSelected(idx: Int) {
        self.input.value = .profileImageNumber(idx)
    }
}

