//
//  CurrentProfileImageView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class CurrentProfileImageView: BaseView {

    lazy var profileImageView = ProfileImageView().then {
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor.mainTheme.cgColor
        $0.alpha = 1
    }
    
    private let cameraImageView = CameraImageView()
    
    override func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(cameraImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(cameraImageView.snp.width)
        }
    }
}

