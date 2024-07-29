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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .opaque)
    }

    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: input)
            .bind { [weak self] output in
                
                guard let self else { return }
                
                switch output {
                case .profileImageNumber(let number):
                    let profileImage = UIImage.profileImages[number]
                    
                    contentView.updateUI(selectedImage: profileImage)
                    deliverProfileImageNumber?(number)
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

