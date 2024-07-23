//
//  ProfileImageCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {

    private let profileImageView = ProfileImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureProfileImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProfileImageView() {
        self.contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCellData(image: UIImage, isSelected: Bool) {
        self.profileImageView.image = image
        self.profileImageView.update(isSelected: isSelected)
    }
}
