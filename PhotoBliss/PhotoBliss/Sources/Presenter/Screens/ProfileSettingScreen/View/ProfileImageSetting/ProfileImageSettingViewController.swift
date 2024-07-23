//
//  ProfileImageSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingView> {
    
    private var viewModel: ProfileImageSettingViewModel
    
    var deliverProfileImageNumber: ((Int) -> Void)?
    
    init(contentView: ProfileImageSettingView, viewModel: ProfileImageSettingViewModel) {
        self.viewModel = viewModel
        super.init(contentView: contentView)
    }

    override func addUserAction() {
        self.contentView.profileImageCollectionView.delegate = self
        self.contentView.profileImageCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform()
            .bind { [weak self] event in
                switch event {
                case .profileImageNumber(let number):
                    self?.updateUI(imageNumber: number)
                    self?.deliverProfileImageNumber?(number)
                }
            }
    }
}

//MARK: - Implement UICollectionViewDelegate/Datasource
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIImage.profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profileImage = UIImage.profileImages[indexPath.item]
        let profileImageView =  self.contentView.currentProfileImageView.profileImageView
        guard let selectedImage = profileImageView.image else { return UICollectionViewCell() }
        let isSelected = (profileImage == selectedImage)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.reusableIdentifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCellData(image: profileImage, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.item
        self.viewModel.input.value = .profileImageNumber(idx)
    }
}

//MARK: - Update Views
extension ProfileImageSettingViewController {
    private func updateUI(imageNumber: Int) {
        let profileImage = UIImage.profileImages[imageNumber]
        let profileImageView =  self.contentView.currentProfileImageView.profileImageView
        
        profileImageView.image = profileImage
        contentView.profileImageCollectionView.reloadData()
    }
}

