//
//  ProfileImageSettingView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import UIKit
import SnapKit
import Then

protocol ProfileImageSettingRootViewDelegate: AnyObject {
    func profileImageSelected(idx: Int)
}

class ProfileImageSettingRootView: BaseView, RootViewProtocol {
    var navigationTitle: String
    
    private let currentProfileImageView = CurrentProfileImageView()
    
    private lazy var profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.reusableIdentifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    weak var delegate: ProfileImageSettingRootViewDelegate?
    
    init(type: ProfileSettingType) {
        self.navigationTitle = type.navigationTitle
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        self.addSubview(currentProfileImageView)
        self.addSubview(profileImageCollectionView)
    }
    
    override func configureLayout() {
        currentProfileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(currentProfileImageView.snp.width)
        }
        
        profileImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(currentProfileImageView.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 50) / 4
        let height = width

        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    func updateUI(selectedImage: UIImage) {
        self.currentProfileImageView.profileImageView.image = selectedImage
        self.profileImageCollectionView.reloadData()
    }
}

//MARK: - CollectionView Setting
extension ProfileImageSettingRootView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIImage.profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profileImage = UIImage.profileImages[indexPath.item]
        let profileImageView = currentProfileImageView.profileImageView
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
        delegate?.profileImageSelected(idx: idx)
    }
}
